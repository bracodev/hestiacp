server {
    listen %ip%:%web_port%;
    server_name %domain_idn% %alias_idn%;
    root %docroot%;

    add_header X-Frame-Options "SAMEORIGIN";
    add_header X-XSS-Protection "1; mode=block";
    add_header X-Content-Type-Options "nosniff";

    index index.html;

    access_log /var/log/nginx/domains/%domain%.log combined;
    access_log /var/log/nginx/domains/%domain%.bytes bytes;
    error_log /var/log/nginx/domains/%domain%.error.log error;

    include %home%/%user%/conf/web/%domain%/nginx.forcessl.conf*;

    location = /favicon.ico {
        log_not_found off;
        access_log off;
    }

    location = /robots.txt {
        allow all;
        log_not_found off;
        access_log off;
    }

    location ~ /\.(?!well-known\/) {
        deny all;
        return 404;
    }

    charset utf-8;

    location / {
        try_files $uri $uri/ /index.html;

        location ~* ^.+\.(ogg|ogv|svg|svgz|swf|eot|otf|woff|woff2|mov|mp3|mp4|webm|flv|ttf|rss|atom|jpg|jpeg|gif|png|webp|ico|bmp|mid|midi|wav|rtf|css|js|jar)$ {
            expires 30d;
            fastcgi_hide_header "Set-Cookie";
        }

    }

    location /error/ {
        alias %home%/%user%/web/%domain%/document_errors/;
    }

    location /vstats/ {
        alias %home%/%user%/web/%domain%/stats/;
        include %home%/%user%/web/%domain%/stats/auth.conf*;
    }

    include /etc/nginx/conf.d/phpmyadmin.inc*;
    include /etc/nginx/conf.d/phppgadmin.inc*;
    include %home%/%user%/conf/web/%domain%/nginx.conf_*;
}
