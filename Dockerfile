FROM ruby:3

# Define o caminho onde vai ficar a aplicacao
ENV INSTALL_PATH /app

# Cria nosso diretório
RUN mkdir -p $INSTALL_PATH

WORKDIR $INSTALL_PATH

# Copia o nosso Gemfile para dentro do container
COPY Gemfile ./

# Instala as Gems
RUN bundle install

# Copia nosso código para dentro do container
COPY . . 

#Liberar a porta
EXPOSE 4567