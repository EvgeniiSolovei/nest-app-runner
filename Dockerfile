FROM --platform=linux/amd64 node:18-alpine as builder

WORKDIR /app

COPY / .

RUN npm install --legacy-peer-deps
RUN npm run build

FROM node:18-alpine

USER node

WORKDIR /app

COPY --from=builder /app/package*.json ./
COPY --from=builder /app/node_modules/ ./node_modules/
COPY --from=builder --chown=node:node /app/src/ ./src/
COPY --from=builder --chown=node:node /app/dist/ ./dist/
COPY --from=builder /app/tsconfig.build.json ./
COPY --from=builder /app/tsconfig.json ./

EXPOSE 3000

CMD ["node", "dist/main"]