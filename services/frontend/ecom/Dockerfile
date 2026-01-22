# ================================
# Stage 1: Développement
# ================================
FROM node:20-alpine AS development

WORKDIR /app

COPY package*.json ./
RUN npm ci --no-audit --no-fund

COPY . .

EXPOSE 5173
CMD ["npm", "run", "dev", "--", "--host", "0.0.0.0"]

# ================================
# Stage 2: Build
# ================================
FROM node:20-alpine AS builder

WORKDIR /app

COPY package*.json ./
RUN npm ci --production=false --no-audit --no-fund

COPY . .
RUN npm run build

# ================================
# Stage 3: Production
# ================================
FROM nginx:alpine AS production

# Copier la config Nginx
COPY nginx.conf /etc/nginx/nginx.conf

# Copier les fichiers buildés
COPY --from=builder /app/dist /usr/share/nginx/html

EXPOSE 80

HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD wget --quiet --tries=1 --spider http://localhost/ || exit 1

CMD ["nginx", "-g", "daemon off;"]