# 🔧 LifeUP - Back-End API

## 📋 Visão Geral

API REST desenvolvida com **Express.js** que gerencia toda a lógica de negócio do LifeUP. Fornece autenticação segura, gerenciamento de produtos, carrinho de compras, pedidos e integração com email.

## 🛠️ Tecnologias

| Tecnologia | Versão | Descrição |
|-----------|--------|-----------|
| Node.js | 16+ | Runtime JavaScript |
| Express.js | 5.2.1 | Framework Web |
| MySQL2 | 3.18.2 | Cliente MySQL |
| JWT | 9.0.3 | Autenticação |
| Nodemailer | 8.0.7 | Envio de emails |
| Helmet | 8.1.0 | Segurança HTTP |
| CORS | 2.8.6 | Controle de origem |
| Morgan | 1.10.1 | Logger HTTP |
| Dotenv | 17.4.2 | Variáveis de ambiente |

## 📦 Instalação

### Pré-requisitos
- Node.js v16 ou superior
- npm ou yarn
- MySQL 5.7 ou superior

### Passos

1. **Clone o repositório:**
   ```bash
   git clone https://github.com/rb0710/LifeUP.git
   cd "LifeUP - Back-End"
   ```

2. **Instale as dependências:**
   ```bash
   npm install
   ```

3. **Configure o banco de dados:**
   ```bash
   mysql -u root -p < lifeup_banco.sql
   ```
   Isso criará a database `lifeup` com todas as tabelas necessárias.

4. **Configure as variáveis de ambiente:**
   
   Crie um arquivo `.env` na raiz:
   ```env
   # Configuração do Banco de Dados
   DB_HOST=localhost
   DB_USER=root
   DB_PASSWORD=sua_senha
   DB_NAME=lifeup
   DB_PORT=3306

   # Configuração de Email (Gmail)
   EMAIL_HOST=smtp.gmail.com
   EMAIL_PORT=587
   EMAIL_USER=seu_email@gmail.com
   EMAIL_PASS=sua_senha_de_app_gmail

   # Configuração JWT
   JWT_SECRET=sua_chave_secreta_super_segura_aqui
   JWT_EXPIRE=7d

   # Ambiente
   NODE_ENV=development
   PORT=3000

   # URLs
   FRONTEND_URL=http://localhost:3001
   BACKEND_URL=http://localhost:3000
   ```

   **Nota sobre Gmail:** 
   - Ative 2FA na sua conta Google
   - Gere uma "Senha de app" em: https://myaccount.google.com/apppasswords
   - Use essa senha no `.env`

5. **Inicie o servidor:**
   ```bash
   # Desenvolvimento (com nodemon)
   npm run dev

   # Produção
   npm start
   ```

   Servidor rodará em `http://localhost:3000`

## 📚 Estrutura de Tabelas do Banco de Dados

### 📋 Tabela: `clientes`
Armazena informações dos usuários do sistema.

```sql
CREATE TABLE clientes (
  id_clientes INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(100) NOT NULL,
  endereco VARCHAR(200) DEFAULT '',
  cpf VARCHAR(11) NOT NULL UNIQUE,
  telefone VARCHAR(20) DEFAULT '',
  email VARCHAR(100) NOT NULL UNIQUE,
  senha VARCHAR(255) NOT NULL,
  data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

### 📦 Tabela: `produtos`
Catálogo de produtos disponíveis.

```sql
CREATE TABLE produtos (
  id_produtos INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(150) NOT NULL,
  descricao TEXT,
  preco DECIMAL(10, 2) NOT NULL,
  quantidade INT NOT NULL DEFAULT 0,
  categoria VARCHAR(50),
  imagem VARCHAR(255),
  data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

### 🛒 Tabela: `carrinho`
Itens do carrinho de compras.

```sql
CREATE TABLE carrinho (
  id_carrinho INT AUTO_INCREMENT PRIMARY KEY,
  id_cliente INT NOT NULL,
  id_produto INT NOT NULL,
  quantidade INT NOT NULL,
  data_adicao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (id_cliente) REFERENCES clientes(id_clientes),
  FOREIGN KEY (id_produto) REFERENCES produtos(id_produtos)
);
```

### 📋 Tabela: `pedidos`
Registra todos os pedidos realizados.

```sql
CREATE TABLE pedidos (
  id_pedidos INT AUTO_INCREMENT PRIMARY KEY,
  id_cliente INT NOT NULL,
  total DECIMAL(10, 2) NOT NULL,
  status VARCHAR(50) DEFAULT 'pendente',
  data_pedido TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (id_cliente) REFERENCES clientes(id_clientes)
);
```

### 📦 Tabela: `itens_pedido`
Itens dentro de cada pedido.

```sql
CREATE TABLE itens_pedido (
  id_item INT AUTO_INCREMENT PRIMARY KEY,
  id_pedido INT NOT NULL,
  id_produto INT NOT NULL,
  quantidade INT NOT NULL,
  preco_unitario DECIMAL(10, 2) NOT NULL,
  FOREIGN KEY (id_pedido) REFERENCES pedidos(id_pedidos),
  FOREIGN KEY (id_produto) REFERENCES produtos(id_produtos)
);
```

## 🔌 Endpoints da API

### 🔐 Autenticação

#### Registrar Novo Usuário
```http
POST /api/auth/registro
Content-Type: application/json

{
  "nome": "João Silva",
  "email": "joao@example.com",
  "senha": "senha_segura_123",
  "cpf": "12345678901",
  "telefone": "11999999999"
}
```

**Resposta (201):**
```json
{
  "success": true,
  "message": "Usuário registrado com sucesso",
  "user": {
    "id": 1,
    "nome": "João Silva",
    "email": "joao@example.com"
  },
  "token": "eyJhbGciOiJIUzI1NiIs..."
}
```

#### Login
```http
POST /api/auth/login
Content-Type: application/json

{
  "email": "joao@example.com",
  "senha": "senha_segura_123"
}
```

**Resposta (200):**
```json
{
  "success": true,
  "token": "eyJhbGciOiJIUzI1NiIs...",
  "user": {
    "id": 1,
    "nome": "João Silva",
    "email": "joao@example.com"
  }
}
```

#### Logout
```http
POST /api/auth/logout
Authorization: Bearer {token}
```

---

### 📦 Produtos

#### Listar Todos os Produtos
```http
GET /api/produtos?categoria=suplementos&limite=10&pagina=1
```

**Resposta (200):**
```json
{
  "success": true,
  "total": 50,
  "pagina": 1,
  "produtos": [
    {
      "id_produtos": 1,
      "nome": "Whey Protein Isolado",
      "descricao": "Proteína de alta qualidade...",
      "preco": 149.90,
      "quantidade": 100,
      "categoria": "suplementos",
      "imagem": "whey.jpg"
    }
  ]
}
```

#### Obter Produto por ID
```http
GET /api/produtos/1
```

**Resposta (200):**
```json
{
  "success": true,
  "produto": {
    "id_produtos": 1,
    "nome": "Whey Protein Isolado",
    "descricao": "Proteína de alta qualidade...",
    "preco": 149.90,
    "quantidade": 100,
    "categoria": "suplementos",
    "imagem": "whey.jpg",
    "data_criacao": "2026-04-22T10:30:00Z"
  }
}
```

#### Criar Novo Produto (Admin)
```http
POST /api/produtos
Authorization: Bearer {token}
Content-Type: application/json

{
  "nome": "Creatina Monohidratada",
  "descricao": "Suplemento para ganho de massa...",
  "preco": 89.90,
  "quantidade": 150,
  "categoria": "suplementos",
  "imagem": "creatina.jpg"
}
```

---

### 🛒 Carrinho

#### Obter Carrinho do Usuário
```http
GET /api/carrinho
Authorization: Bearer {token}
```

**Resposta (200):**
```json
{
  "success": true,
  "total": 299.80,
  "itens": [
    {
      "id_carrinho": 1,
      "id_produto": 1,
      "nome": "Whey Protein",
      "preco": 149.90,
      "quantidade": 2,
      "subtotal": 299.80
    }
  ]
}
```

#### Adicionar ao Carrinho
```http
POST /api/carrinho
Authorization: Bearer {token}
Content-Type: application/json

{
  "id_produto": 1,
  "quantidade": 2
}
```

**Resposta (201):**
```json
{
  "success": true,
  "message": "Produto adicionado ao carrinho",
  "carrinho": { ... }
}
```

#### Remover do Carrinho
```http
DELETE /api/carrinho/1
Authorization: Bearer {token}
```

#### Atualizar Quantidade
```http
PUT /api/carrinho/1
Authorization: Bearer {token}
Content-Type: application/json

{
  "quantidade": 3
}
```

---

### 📋 Pedidos

#### Criar Novo Pedido
```http
POST /api/pedidos
Authorization: Bearer {token}
Content-Type: application/json

{
  "endereco": "Rua das Flores, 123",
  "cidade": "São Paulo",
  "cep": "01234-567"
}
```

**Resposta (201):**
```json
{
  "success": true,
  "message": "Pedido criado com sucesso",
  "pedido": {
    "id_pedidos": 1,
    "id_cliente": 1,
    "total": 299.80,
    "status": "confirmado",
    "data_pedido": "2026-04-29T10:30:00Z",
    "itens": [ ... ]
  }
}
```

#### Listar Pedidos do Usuário
```http
GET /api/pedidos
Authorization: Bearer {token}
```

**Resposta (200):**
```json
{
  "success": true,
  "pedidos": [
    {
      "id_pedidos": 1,
      "total": 299.80,
      "status": "entregue",
      "data_pedido": "2026-04-29T10:30:00Z"
    }
  ]
}
```

#### Obter Detalhes do Pedido
```http
GET /api/pedidos/1
Authorization: Bearer {token}
```

#### Atualizar Status do Pedido (Admin)
```http
PUT /api/pedidos/1
Authorization: Bearer {token}
Content-Type: application/json

{
  "status": "enviado"
}
```

---

### 👤 Perfil

#### Obter Dados do Perfil
```http
GET /api/perfil
Authorization: Bearer {token}
```

**Resposta (200):**
```json
{
  "success": true,
  "usuario": {
    "id_clientes": 1,
    "nome": "João Silva",
    "email": "joao@example.com",
    "cpf": "12345678901",
    "telefone": "11999999999",
    "endereco": "Rua das Flores, 123"
  }
}
```

#### Atualizar Perfil
```http
PUT /api/perfil
Authorization: Bearer {token}
Content-Type: application/json

{
  "nome": "João Silva Santos",
  "telefone": "11988888888",
  "endereco": "Rua Nova, 456"
}
```

#### Alterar Senha
```http
POST /api/perfil/alterar-senha
Authorization: Bearer {token}
Content-Type: application/json

{
  "senha_atual": "senha_antiga_123",
  "nova_senha": "senha_nova_456"
}
```

---

## 🔒 Segurança

### Headers de Segurança
- **Helmet.js**: Proteção contra XSS, clickjacking e outros ataques
- **CORS**: Validação de origem das requisições
- **JWT**: Tokens com expiração de 7 dias
- **Variáveis de Ambiente**: Credenciais protegidas

### Boas Práticas
- Senhas criptografadas no banco de dados
- Validação de entrada em todos os endpoints
- Rate limiting recomendado para produção
- HTTPS obrigatório em produção

## 📧 Configuração de Email

### Gmail (Recomendado)

1. Ative autenticação de 2 fatores
2. Gere uma "Senha de app": https://myaccount.google.com/apppasswords
3. Configure no `.env`:
   ```env
   EMAIL_HOST=smtp.gmail.com
   EMAIL_PORT=587
   EMAIL_USER=seu_email@gmail.com
   EMAIL_PASS=senha_de_app_gerada
   ```

### Outros Provedores

**Microsoft Outlook:**
```env
EMAIL_HOST=smtp-mail.outlook.com
EMAIL_PORT=587
EMAIL_USER=seu_email@outlook.com
EMAIL_PASS=sua_senha
```

**SendGrid:**
```env
EMAIL_HOST=smtp.sendgrid.net
EMAIL_PORT=587
EMAIL_USER=apikey
EMAIL_PASS=SG.xxxxxxxxxxxxx
```

## 🧪 Testes

### Testar com Postman
1. Importe a coleção: [LifeUP-API.postman_collection.json](./postman-collection.json)
2. Configure as variáveis de ambiente no Postman
3. Execute os testes

### Testar com cURL
```bash
# Registrar usuário
curl -X POST http://localhost:3000/api/auth/registro \
  -H "Content-Type: application/json" \
  -d '{
    "nome": "João Silva",
    "email": "joao@example.com",
    "senha": "senha123",
    "cpf": "12345678901"
  }'

# Login
curl -X POST http://localhost:3000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "joao@example.com",
    "senha": "senha123"
  }'
```

## 📊 Variáveis de Ambiente Completas

```env
# ==========================================
# BANCO DE DADOS
# ==========================================
DB_HOST=localhost
DB_USER=root
DB_PASSWORD=sua_senha
DB_NAME=lifeup
DB_PORT=3306
DB_POOL_LIMIT=10

# ==========================================
# EMAIL
# ==========================================
EMAIL_HOST=smtp.gmail.com
EMAIL_PORT=587
EMAIL_SECURE=false
EMAIL_USER=seu_email@gmail.com
EMAIL_PASS=sua_senha_de_app

# ==========================================
# SEGURANÇA
# ==========================================
JWT_SECRET=sua_chave_secreta_muito_segura
JWT_EXPIRE=7d
BCRYPT_ROUNDS=10

# ==========================================
# SERVIDOR
# ==========================================
NODE_ENV=development
PORT=3000
LOG_LEVEL=debug

# ==========================================
# URLs
# ==========================================
FRONTEND_URL=http://localhost:3001
BACKEND_URL=http://localhost:3000
API_PREFIX=/api

# ==========================================
# RATE LIMITING
# ==========================================
RATE_LIMIT_WINDOW_MS=900000
RATE_LIMIT_MAX_REQUESTS=100
```

## 🚀 Deploy em Produção

### Variáveis Críticas para Produção
```env
NODE_ENV=production
HTTPS_ENABLED=true
CORS_ORIGIN=https://seu-dominio.com
JWT_SECRET=chave_super_secreta_aleatoria
DB_PASSWORD=senha_forte_do_mysql
EMAIL_PASS=senha_de_app_gmail
```

### Recomendações
- Use um serviço de banco de dados gerenciado (RDS, Azure MySQL)
- Configure SSL/TLS (Let's Encrypt)
- Use variáveis de ambiente seguras (AWS Secrets Manager, Azure KeyVault)
- Implemente rate limiting
- Configure logs centralizados
- Use PM2 ou similar para gerenciar processos Node.js

## 📝 Logs

Os logs são salvos em:
- **Console**: Saída padrão
- **Morgan**: Logs HTTP em desenvolvimento
- **Arquivo**: `logs/` (estrutura pode ser implementada)

## 🐛 Troubleshooting

### Erro: "Connection refused"
- Verifique se MySQL está rodando
- Confirme as credenciais no `.env`
- Verifique a porta (padrão 3306)

### Erro: "Invalid token"
- Token expirou (gere um novo)
- Token malformado
- Secret JWT não corresponde

### Erro: "Email not sent"
- Verifique credenciais do Gmail
- Ative "Menos seguro" ou use "Senha de app"
- Confirme a conexão com a internet

## 📞 Suporte

Para dúvidas ou problemas:
- Abra uma issue no GitHub
- Entre em contato: suporte@lifeup.com

---

**Desenvolvido com ❤️ para oferecer a melhor experiência de compra**
