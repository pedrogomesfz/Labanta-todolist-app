# Dockerfile

# Estágio 1: Build
FROM node:18-alpine AS builder

# Definir diretório de trabalho
WORKDIR /app

# Copiar ficheiros de dependências
COPY package*.json ./

# Instalar dependências (incluindo devDependencies para desenvolvimento)
RUN npm ci

# Copiar o resto do código
COPY . .

# Estágio 2: Produção (opcional, mas recomendado)
FROM node:18-alpine

# Instalar ferramentas úteis (opcional)
RUN apk add --no-cache curl

# Definir diretório de trabalho
WORKDIR /app

# Copiar dependências do estágio builder
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/package*.json ./
COPY . .

# Criar utilizador não-root para segurança
RUN addgroup -g 1001 -S nodejs && \
    adduser -S nodejs -u 1001

# Mudar para utilizador não-root
USER nodejs

# Expor a porta da aplicação
EXPOSE 3000

# Comando para iniciar a aplicação
CMD ["npm", "run", "dev"]