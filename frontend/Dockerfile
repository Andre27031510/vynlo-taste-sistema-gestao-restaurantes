FROM node:18-alpine AS builder

RUN apk add --no-cache libc6-compat
WORKDIR /app

COPY package*.json ./
# Instala com devDependencies para compilar TypeScript/Next
RUN npm ci

COPY . .
RUN npm run build
# Remove devDependencies para imagem final menor
RUN npm prune --omit=dev

FROM node:18-alpine
WORKDIR /app
ENV NODE_ENV=production

COPY --from=builder /app .

EXPOSE 3000

HEALTHCHECK --interval=30s --timeout=10s --start-period=30s --retries=3 \
    CMD wget -qO- http://localhost:3000/ || exit 1

CMD ["npm", "run", "start"]