from django.shortcuts import render
from django.contrib.auth.decorators import login_required
from django.contrib.admin.views.decorators import staff_member_required
from integrations.models import Release
from notifications.forms import EmailNotificationForm, TelegramNotificationForm
from django.db import connection
import cx_Oracle

@login_required
def index(request):
    user_id = request.user.id

    integration = None
    if request.user.integration_set.filter(identifier='spotify').exists():
        integration = request.user.integration_set.get(identifier='spotify')
    elif request.user.integration_set.filter(identifier='deezer').exists():
        integration = request.user.integration_set.get(identifier='deezer')

    cursor = connection.cursor()
    cursor.execute("select * from table(releases.latest_releases)")
    headers = ('title', 'date', 'cover_url', 'artist_name')
    releases = cursor.fetchall()
    releases = [dict(zip(headers, release)) for release in releases]

    # releases = Release.objects.filter(artist__integration_id=integration.id).order_by('-date')[:200]
    context = {'user': request.user, 'releases': releases}
    return render(request, 'releases/index.html', context)

@login_required
def settings(request):
    notifications = request.user.notification_set

    email_notification = notifications.get(channel="email")
    channel_id = email_notification.channel_id or request.user.email
    enabled = email_notification.enabled
    email_notification_form_data = {
        'channel_id': channel_id,
        'enabled': enabled,
        'notification_id': email_notification.id,
    }
    email_notification_form = EmailNotificationForm(email_notification_form_data)

    telegram_notification_form = None
    if notifications.filter(channel="telegram").exists():
        telegram_notification = notifications.get(channel="telegram")
        enabled = telegram_notification.enabled
        telegram_notification_form_data = {
            'enabled': enabled,
            'channel_id': telegram_notification.channel_id,
            'notification_id': telegram_notification.id,
        }
        telegram_notification_form = TelegramNotificationForm(telegram_notification_form_data)

    context = {
        'user': request.user,
        'email_notification_form': email_notification_form,
        'telegram_notification_form': telegram_notification_form,
    }
    return render(request, 'settings/index.html', context)

@login_required
def artist(request, name):
    integration = None
    if request.user.integration_set.filter(identifier='spotify').exists():
        integration = request.user.integration_set.get(identifier='spotify')
    elif request.user.integration_set.filter(identifier='deezer').exists():
        integration = request.user.integration_set.get(identifier='deezer')

    cursor = connection.cursor()
    cursor.execute("select * from table(releases.artist_releases(:name))", {'name':name})
    releases = cursor.fetchall()
    headers = ('title', 'date', 'cover_url', 'artist_name')
    releases = [dict(zip(headers, release)) for release in releases]
    # artist = integration.artist_set.get(name__iexact=name)
    # releases = artist.release_set.all().order_by('-date')
    artist_name = releases[0]['artist_name']

    context = {'artist_name': artist_name, 'releases': releases}
    return render(request, 'artists/show.html', context)

@staff_member_required
def admin_dashboard(request):
    from django.contrib.auth.models import User
    from integrations.models import Integration
    from notifications.models import Notification
    from django.db.models import Count
    import matplotlib.pyplot as plt
    import mpld3

    # total_users_count = User.objects.count()
    cursor = connection.cursor()
    total_users_count = int(cursor.callfunc('users_pack.total_users', cx_Oracle.NUMBER))

    # total_integrations_count = Integration.objects.count()
    total_integrations_count = int(cursor.callfunc('integrations.total_integrations', cx_Oracle.NUMBER))
    cursor.execute("select * from table(integrations.integrations_by_identifier)")
    integrations_by_identifier = cursor.fetchall()
    headers = ('count', 'identifier')
    integrations_by_identifier = [dict(zip(headers, entity)) for entity in integrations_by_identifier]
    # integrations_by_identifier = Integration.objects.values('identifier').annotate(count=Count('identifier'))

    x = [integration['count'] for integration in integrations_by_identifier]
    labels = [integration['identifier'] for integration in integrations_by_identifier]
    fig = plt.figure(figsize=(5, 5))
    positions = range(len(x))
    plt.bar(positions, x, color='lightblue')
    plt.xticks(positions, labels)
    integrations_by_identifier_chart = mpld3.fig_to_html(fig)

    # total_notifications_count = Notification.objects.count()
    total_notifications_count = int(cursor.callfunc('notifications.total_notifications', cx_Oracle.NUMBER))
    cursor.execute("select * from table(notifications.notifications_by_identifier)")
    notifications_by_identifier = cursor.fetchall()
    headers = ('count', 'channel')
    notifications_by_identifier = [dict(zip(headers, entity)) for entity in notifications_by_identifier]
    # notifications_by_identifier = Notification.objects.values('channel').annotate(count=Count('channel'))

    x = [notification['count'] for notification in notifications_by_identifier]
    labels = [notification['channel'] for notification in notifications_by_identifier]
    fig = plt.figure(figsize=(5, 5))
    positions = range(len(x))
    plt.bar(positions, x, color='lightblue')
    plt.xticks(positions, labels)
    notifications_by_identifier_chart = mpld3.fig_to_html(fig)

    context = {
        'total_users_count': total_users_count,
        'total_integrations_count': total_integrations_count,
        'integrations_by_identifier_chart': integrations_by_identifier_chart,
        'total_notifications_count': total_notifications_count,
        'notifications_by_identifier_chart': notifications_by_identifier_chart,
    }
    return render(request, 'admin/dashboard.html', context)
