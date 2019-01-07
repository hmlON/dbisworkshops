from notifications.models import Notification
from django.db import connection
import cx_Oracle

def create_default_notifications(backend, user, response, *args, **kwargs):
    cursor = connection.cursor()
    cursor.callfunc(
        'notifications.create_notification',
        cx_Oracle.STRING,
        [user.id, 'email', None]
    )
    # if not Notification.objects.filter(user=user, channel="email").exists():
    #     Notification.objects.create(user=user, channel="email")
