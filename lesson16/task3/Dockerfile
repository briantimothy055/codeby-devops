FROM node:16-alpine AS build
WORKDIR /web-app
RUN mkdir -p /web-app/build
RUN echo "APP BUILD TIME: $(date)" > /web-app/build/index.html

FROM nginx:alpine
COPY --from=build /web-app/build/index.html /usr/share/nginx/html
