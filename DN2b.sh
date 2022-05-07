#!/bin/bash
ps -o pid:1,args:1 --sort -start_time --no-headers $(pidof $1) | cut -d' ' -f1,3-


#lahko problem če je proces v mapi z presledki (kar nebi smel biti)