#!/bin/bash

#note: run this with sudo bash -c './make_file_system.sh'

#banner
cat <<BANNER> /etc/motd
  ________      _______ _      _____ ____  _____  _____  
 |  ____\ \    / /_   _| |    / ____/ __ \|  __ \|  __ \ 
 | |__   \ \  / /  | | | |   | |   | |  | | |__) | |__) |
 |  __|   \ \/ /   | | | |   | |   | |  | |  _  /|  ___/ 
 | |____   \  /   _| |_| |___| |___| |__| | | \ \| |     
 |______|   \/   |_____|______\_____\____/|_|  \_\_|     
      
             Welcome to Evilcorp Mail Server!                                                   
                Check your mail in /mail 
                
>You have mail.
                                           
BANNER
#make basic folder
cd /
mkdir mail
cd mail

#make users
mkdir 3v1l-m4n4ger
mkdir bob-lunder
mkdir inigo-monyata
mkdir tyler-dunder
mkdir ernest-viladmin

#"regular" users > write generic mail
REGULAR_MAIL=$(cat <<'EOF'

Dear user,

As a means of ensuring flawless and perfect security in our infrastructure, a new server called "Hyper Critical Security Hypervisor" has been setup. This server will handle and analyze ALL traffic in the network, and guarantee data-leak protection and ethical compliance. It also locks most of the management functions and should prevent further attacks on our system.
Do not, under ANY circumstances, attempt to access or modify this server.

Yours evilly,
Management
EOF
)

#"special" mail > bob and ernest
BOB_MAIL=$(cat <<'EOF'

I swear on the Lord, Bob.

You've made my life hell, and since I know you're dumber than a rock and thicker than oatmeal, I'll spell it out for you: Do NOT fiddle with the "Security Hypervisor". It's an obvious honeypot for that hacker that has been messing with us. If you try to disable it by any means, a lambda will come hard on you and most likely kill all of your privileges.

Don't fiddle with the lambdas, too. The other one is made to ensure post-mortems are doable if the database server comes down. There shouldn't be any logs appearing in AWS' logging system, but just in case, don't touch them.

Do not make me reset your privileges for you if you end up getting a strike, or I swear, your next computer will use punched cards.

E.Viladmin
EOF
)

#"mails deleted" > manager
MANAGER_MAIL=$(cat <<'EOF'

Dear X,

Remember to clear your mailbox. Nothing is safe for now.

Y.
EOF
)

#Setup!
cd 3v1l-m4n4ger
touch "mailfrom: Y; on: 25_11_20XX.txt"
echo "mailfrom: Y; on: 25_11_20XX.txt" > "mailfrom: Y; on: 25_11_20XX.txt"
echo "$MANAGER_MAIL" >> "mailfrom: Y; on: 25_11_20XX.txt"
cd ..

cd inigo-monyata
touch "mailfrom: ernest-viladmin; on: 24_11_20XX.txt"
echo "mailfrom: ernest-viladmin; on: 24_11_20XX.txt" > "mailfrom: ernest-viladmin; on: 24_11_20XX.txt"
echo "$REGULAR_MAIL" >> "mailfrom: ernest-viladmin; on: 24_11_20XX.txt"
cd ..

cd tyler-dunder
touch "mailfrom: ernest-viladmin; on: 24_11_20XX.txt"
echo "mailfrom: ernest-viladmin; on: 24_11_20XX.txt" > "mailfrom: ernest-viladmin; on: 24_11_20XX.txt"
echo "$REGULAR_MAIL" >> "mailfrom: ernest-viladmin; on: 24_11_20XX.txt"
cd ..

cd bob-lunder
touch "mailfrom: ernest-viladmin; on: 24_11_20XX.txt"
echo "mailfrom: ernest-viladmin; on: 24_11_20XX.txt" > "mailfrom: ernest-viladmin; on: 24_11_20XX.txt"
echo "$REGULAR_MAIL" >> "mailfrom: ernest-viladmin; on: 24_11_20XX.txt"

touch "mailfrom: ernest-viladmin; on: 25_11_20XX.txt"
echo "mailfrom: ernest-viladmin; on: 25_11_20XX.txt" > "mailfrom: ernest-viladmin; on: 25_11_20XX.txt"
echo "$BOB_MAIL" >> "mailfrom: ernest-viladmin; on: 25_11_20XX.txt"
cd ..

cd ernest-viladmin
touch "mailfrom: ernest-viladmin; on: 24_11_20XX.txt"
echo "mailfrom: ernest-viladmin; on: 24_11_20XX.txt" > "mailfrom: ernest-viladmin; on: 24_11_20XX.txt"
echo "$REGULAR_MAIL" >> "mailfrom: ernest-viladmin; on: 24_11_20XX.txt"

touch "mailto: all; on: 24_11_20XX.txt"
echo "mailto: all; on: 24_11_20XX.txt" > "mailto: all; on: 24_11_20XX.txt"
echo "$REGULAR_MAIL" >> "mailto: all; on: 24_11_20XX.txt"

touch "mailto: bob-lunder; on: 25_11_20XX.txt"
echo "mailto: bob-lunder; on: 25_11_20XX.txt" > "mailto: bob-lunder; on: 25_11_20XX.txt"
echo "$BOB_MAIL" >> "mailto: bob-lunder; on: 25_11_20XX.txt"


#clean self
cd /home/ec2-user
rm make_mail_system.sh

