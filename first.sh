#!/bin/bash
send_email_alert() {
  hostname=$(hostname)

  mail -s "Server Alert" galievav44@gmail.com << EOF
Server: $(hostname)
Time: $(date '+%Y-%m-%d %H:%M:%S')

$1 usage critical! $1 usage is at $2% on $hostname. Please check the server immediately.
EOF

}

send_email_alert "CPU" 95