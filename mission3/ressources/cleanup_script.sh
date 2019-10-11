#!/bin/bash

zip --password ForeverDoingEvil secretdata.zip ./chonks/
rm -rf chonks/

echo "
I warned you, Bob.

It is the SECOND TIME a hacker has sent our precious plans cartwheeling by breaking in our servers, and all of this because you manage to f***-up the configuration each time.
I pulled this script on there to cipher whatever data you did not think of protecting, but I swear on God, you are making my life hell.
I got in touch with management about this, and I tell you, tomorrow I'm gonna wipe myself with your termination notice.

-t. The IT guy whose life you ruined." >> bob_come_on.txt

rm cleanup_script.sh
