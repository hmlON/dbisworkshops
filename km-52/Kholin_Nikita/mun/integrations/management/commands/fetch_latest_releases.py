from django.core.management.base import BaseCommand, CommandError
from django.contrib.auth.models import User
from integrations.music_service_fetchers.deezer_fetcher import DeezerFetcher
from integrations.music_service_fetchers.spotify_fetcher import SpotifyFetcher
from integrations.models import Release
from django.core.mail import send_mail
import datetime
import os
import requests
from django.db import connection
import cx_Oracle

class Command(BaseCommand):
    help = 'Fetches latest releases'

    def handle(self, *args, **options):
        users = User.objects.all()

        for user in users:
            self.stdout.write(self.style.SUCCESS(f'starting fetching for {user.email}'))

            integration = None
            if user.integration_set.filter(identifier='spotify').exists():
                integration = user.integration_set.get(identifier='spotify')
                SpotifyFetcher.fetch(user.id)
            elif user.integration_set.filter(identifier='deezer').exists():
                integration = user.integration_set.get(identifier='deezer')
                DeezerFetcher.fetch(user.id)

            if not integration:
              continue

            self.stdout.write(self.style.SUCCESS(f'finished fetching for {user.email}'))


            if user.notification_set.filter(channel='email', enabled=True).exists():
                notification = user.notification_set.get(channel='email')
                new_since = notification.last_sent_at.date()
                new_since = datetime.date.today() - datetime.timedelta(days=30)

                cursor = connection.cursor()
                cursor.execute("select * from table(releases.releases_from_time(:from_date, :integration_id))", {'from_date':new_since, 'integration_id':integration.id})
                new_releases = cursor.fetchall()
                headers = ('title', 'date', 'cover_url', 'artist_name')
                new_releases = [dict(zip(headers, release)) for release in new_releases]
                # new_releases = Release.objects.filter(
                #     artist__integration_id=integration.id,
                #     date__gte=new_since,
                #     created_at__gte=new_since,
                # ).order_by('-date')


                # send an email
                if len(new_releases) > 0:
                    self.stdout.write(self.style.SUCCESS(f'sending an email for {user.email} '))

                    releases_text = [f"{release['date']}: {release['artist_name']} - {release['title']}" for release in new_releases]
                    intro_text = 'Here are latest music releases that you have not seen before:'
                    email_text = '\n'.join([intro_text] + releases_text)

                    send_mail(
                        f'New music releases since {new_since}',
                        email_text,
                        '"MuN: latest releases" <latest.releases@musicnotifier.com>',
                        [user.email],
                        fail_silently=False,
                    )

                    notification.last_sent_at = datetime.datetime.now()
                    notification.save()
                else:
                    self.stdout.write(self.style.SUCCESS(f'no new releases {user.email}'))


            # send a telegram message
            if user.notification_set.filter(channel='telegram', enabled=True).exists():
                notification = user.notification_set.get(channel='telegram')
                new_since = notification.last_sent_at.date()
                # new_since = datetime.date.today() - datetime.timedelta(days=7)
                
                cursor = connection.cursor()
                cursor.execute("select * from table(releases.releases_from_time(:from_date, :integration_id))", {'from_date':new_since, 'integration_id':integration.id})
                new_releases = cursor.fetchall()
                headers = ('title', 'date', 'cover_url', 'artist_name')
                new_releases = [dict(zip(headers, release)) for release in new_releases]

                if len(new_releases) > 0:
                    self.stdout.write(self.style.SUCCESS(f'sending a telegram message for {notification.channel_id} '))

                    releases_text = [f"{release['date']}: {release['artist_name']} - {release['title']}" for release in new_releases]
                    intro_text = 'Here are latest music releases that you have not seen before:'
                    text = '\n'.join([intro_text] + releases_text)

                    bot_key = os.environ.get('TELEGRAM_API_KEY')
                    chat_id = notification.channel_id
                    send_message_url = f'https://api.telegram.org/bot{bot_key}/sendMessage?chat_id={chat_id}&text={text}'
                    requests.post(send_message_url)

                    # update last sent at
                    notification.last_sent_at = datetime.datetime.now()
                    notification.save()
                else:
                    self.stdout.write(self.style.SUCCESS(f'no new releases {notification.channel_id}'))
