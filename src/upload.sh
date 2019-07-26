#!/bin/bash

sftp www.team-frickel.de:/vhost/team-frickel.de/htdocs/bashsex/ <<End
lcd ..
put README.html index.html
put -r strapdown
End
