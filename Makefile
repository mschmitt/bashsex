all:
	mkdocs build --clean
	cd site/css/ && echo '.rst-content > div:nth-child(1) { display: none; };' >> theme_extra.css
	cd site/css/ && curl -O https://cdnjs.cloudflare.com/ajax/libs/highlight.js/9.12.0/styles/github.min.css
	cd site/js/  && curl -O https://cdnjs.cloudflare.com/ajax/libs/highlight.js/9.12.0/highlight.min.js
	find site -name '*html' -print0 | xargs -0 sed -i 's|https://.*/github.min.css|../css/github.min.css|'
	find site -name '*html' -print0 | xargs -0 sed -i 's|https://.*/highlight.min.js|../js/highlight.min.js|'
	find site -name '*html' -print0 | xargs -0 sed -i '/fonts.googleapis.com/s/\(.*\)/<!-- \1 -->/'
	rsync --archive --chmod=u=rwX,go=rX --delete --verbose site/ team-frickel.de:/vhost/team-frickel.de/htdocs/bashsex/
