#!/bin/bash

zip -q -r --password ForeverDoingEvil secretdata.zip ./chonks/
rm -rf chonks/

rm bob_todo.txt

echo "
I warned you, Bob.

It is the SECOND TIME a hacker has sent our precious plans cartwheeling by breaking in our servers, and all of this because you manage to f***-up the configuration each time.
I pulled this script on there to cipher whatever data you did not think of protecting, but I swear on God, you are making my life hell.
I got in touch with management about this, and I tell you, tomorrow I'm gonna wipe myself with your termination notice.
Next time I have to patch one of your mistakes, I will put salt in your morning coffee.

Lovingly,
The IT guy whose life you ruined.

PS: What the hell is this snapshot you made? Delete this fast." >> bob_come_on.txt

rm cleanup_script.sh
