FROM node:20 AS build
WORKDIR /app
COPY package.json yarn.lock ./
RUN yarn install
COPY . .

ARG API_URL=http://localhost:8000/api
RUN sed -i "s|__API_URL__|${API_URL}|g" src/environments/environment.ts

RUN yarn build

FROM nginx:alpine
COPY --from=build /app/dist/angular-conduit /usr/share/nginx/html
EXPOSE 80