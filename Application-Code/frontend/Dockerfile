FROM node:18-alpine AS build

WORKDIR /usr/src/app

ENV NODE_OPTIONS=--openssl-legacy-provider
ARG REACT_APP_API_URL=/api/tasks
ENV REACT_APP_API_URL=$REACT_APP_API_URL

COPY package*.json ./

RUN npm install

COPY . .

RUN npm run build

FROM nginx:alpine

COPY --from=build /usr/src/app/build /usr/share/nginx/html

COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 3000

CMD ["nginx", "-g", "daemon off;"]
