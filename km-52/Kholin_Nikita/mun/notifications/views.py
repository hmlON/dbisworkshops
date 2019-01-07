from django.contrib.auth.decorators import login_required
from django.shortcuts import redirect
from django.http import HttpResponse
from secrets import token_urlsafe
from django.views.decorators.csrf import csrf_exempt
import json
from notifications.models import Notification
import requests
import os
from django.db import connection
import cx_Oracle

@login_required
def create(request):
    # notification, _created = request.user.notification_set.get_or_create(
    #   channel='telegram',
    #   defaults={'connect_token': token_urlsafe(8)}
    # )
    connect_token = token_urlsafe(8)
    cursor = connection.cursor()
    cursor.callfunc(
        'notifications.create_notification',
        cx_Oracle.STRING,
        [request.user.id, 'telegram', token_urlsafe(8)]
    )

    bot_url = 'https://www.telegram.me/music_notification_bot'
    return redirect(f'{bot_url}?start={connect_token}')

@csrf_exempt
def callback(request):
    body = json.loads(request.body)
    text = body['message']['text'].split(' ')
    token = None
    if len(text) > 1:
        token = text[1]

    bot_key = os.environ.get('TELEGRAM_API_KEY')
    chat_id = body['message']['chat']['id']

    try:
        notification = Notification.objects.get(channel='telegram', connect_token=token)
        cursor = connection.cursor()
        cursor.callfunc(
            'notifications.update_notification',
            cx_Oracle.STRING,
            [notification_id, notification.enabled, chat_id]
        )
        # notification.channel_id = chat_id
        # notification.save()

        text = "Welcome to the MuN"
        send_message_url = f'https://api.telegram.org/bot{bot_key}/sendMessage?chat_id={chat_id}&text={text}'
        requests.post(send_message_url)

        return HttpResponse()
    except Notification.DoesNotExist:
        text = "Sorry, seems like the MuN is too far..."
        send_message_url = f'https://api.telegram.org/bot{bot_key}/sendMessage?chat_id={chat_id}&text={text}'
        requests.post(send_message_url)

        return HttpResponse()

@login_required
def notification_update(request):
    notification_id = request.POST.get('notification_id')
    cursor = connection.cursor()
    cursor.callfunc(
        'notifications.update_notification',
        cx_Oracle.STRING,
        [notification_id, int(bool(request.POST.get('enabled'))), request.POST.get('channel_id')]
    )
    # notification = Notification.objects.get(id=notification_id)
    # notification.enabled = bool(request.POST.get('enabled'))
    # notification.channel_id = request.POST.get('channel_id')
    # notification.save()
    return redirect('/settings')
