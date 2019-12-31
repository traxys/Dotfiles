""" Module to alert when the time
is past a mark"""

import datetime

class Py3status:

    alert_hour = 2

    def alerted_time(self):
        time = datetime.datetime.now()
        color = "#b0b0b0"
        if datetime.time(hour=6) >= time.time() >= datetime.time(hour=self.alert_hour):
            color = "#FF0000"
        return {
            'full_text': time.strftime('%d/%m/%Y %H:%M'),
            'color': color,
            'cached_until': self.py3.time_in(5)
        }
