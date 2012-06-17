#!/usr/bin/env python
#
# Send SMS via GSM modem from Python
# Version: 0.2b
# File: "send_sms.py"
# Copyright (C) 2007, Alex Grinkov
# Licensed by GNU General Public License version 2
# Last update: 2007.12.14

import os

def send_sms(
    phone,                 # phone number like "+79061234567"
    text,                  # short message text
    modem="/dev/ttyACM0"): # modem device like "/dev/ttyUSB0"
  """Send SMS via GSM modem"""
  fd = os.open(modem, os.O_RDWR)
  # os.write(fd, "ATZ,ATE0") # need for Motorola C390
  os.write(fd, "AT+CMGF=1 \015")
  os.write(fd, "AT+CMGS=\"" + phone+ "\" \015")
  os.write(fd, text + " \015")
  os.write(fd, "\032")
  os.close(fd)
  #print "Send SMS to number %s. Text is: '%s'" % (phone, text)

if __name__ == "__main__":
  print "Send SMS"
  print "    Phone number:",
  phone = raw_input()
  print "    Text        :",
  text = raw_input()

  send_sms(phone, text, "/dev/ttyUSB2")

#*** end of "send_sms.py" file ***#
