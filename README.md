
# Timesync - Sistema de Gestão de Apontamentos

Este repositório contém a configuração Docker para um banco de dados MySQL com a estrutura do sistema Timesync, destinado ao gerenciamento de apontamentos de horas em projetos.

## 📋 Pré-requisitos

- Docker

- Docker Compose

## 🚀 Como executar

### 1. Configurar variáveis de ambiente

Copie o arquivo de exemplo de variáveis de ambiente:

```bash
cp .env.example .env
```

Edite o arquivo ```.env``` com suas credenciais:

```bash
MYSQL_ROOT_PASSWORD=senha_root
MYSQL_DATABASE=Timesync
MYSQL_USER=usuario_app
MYSQL_PASSWORD=senha_app
```

### 2. Executar o container

```bash
docker compose up -d
```

### 3. Verificar se o container está rodando

```bash
docker ps 
```

## 📊 Estrutura do Banco de Dados

O banco de dados ```Timesync``` contém as seguintes tabelas:

### Tabelas Principais:

- estado_dados: Controla o estado dos registros (ativo/inativo)

- cargo_usuario: Armazena os cargos dos usuários

- usuarios: Cadastro de usuários do sistema

- projetos: Cadastro de projetos

- apontamentos: Registro de apontamentos de horas

- equipe: Definição de equipes

- assoc_usuario_projetos: Associação entre usuários e projetos

- assoc_cargo_equipe: Associação entre cargos, equipes e usuários

## 🔌 Conexão com o Banco

- Host: localhost

- Porta: 3306

- Banco: Timesync

- Usuário: Definido no arquivo .env

- Senha: Definida no arquivo .env

### Exemplo de conexão Mysql

```bash
mysql -h 127.0.0.1 -P 3306 -u usuario_app -p
```

## 📁 Estrutura de Arquivos

```text
├── docker-compose.yml
├── Dockerfile
├── .env-example
└── init/
    ├── 01-create-schema.sql
    └── 02-insert-sample-data.sql
```

## 🛠 Comandos Úteis

### Parar o container:

```bash
docker compose down -v
```

### Ver logs do container:

```bash
docker compose logs mysql
```

### Acessar o container:

```bash
docker exec -it mysql-container mysql -u usuario_app -p
```

### Reiniciar o container:

```bash
docker compose restart
```

## ⚠️ Notas Importantes

- O arquivo ```.env``` contém credenciais sensíveis e não deve ser commitado no repositório

- Os scripts SQL no diretório ```init/``` são executados automaticamente na inicialização

- O banco de dados é persistido via volumes do Docker

- A porta ```3306``` do host está mapeada para o container

## 🔒 Segurança

- Altere as senhas padrão no arquivo ```.env```

- Mantenha o arquivo ```.env``` seguro e fora do controle de versão

## 🐛 Solução de Problemas

Se encontrar problemas:

1. Verifique se a porta 3306 não está em uso:

```bash
netstat -tulpn | grep 3306
```

2. Verifique os logs do container:

```bash
docker compose logs mysql-container
```

3. Certifique-se de que o arquivo ```.env``` existe e está configurado corretamente

## 📝 Autor:

- Este projeto pertence a equipe de desenvolvimento da Timesync
- Desenvolvedores responsáveis:
    - [DaviRdaSilva](https://github.com/DaviRdaSilva)
