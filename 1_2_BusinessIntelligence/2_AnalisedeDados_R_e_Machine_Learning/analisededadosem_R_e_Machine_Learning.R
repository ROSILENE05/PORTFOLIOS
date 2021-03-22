# aprendendo linguagem R
mensagem <- "Hello world!"

# CARREGANDO OS DADOS
?read.csv # consultar documentação

# se o arquivo estiver com as barras assim \ tem que trocar para /
viagens <- read.csv(
  file = "C:/Users/rosil/OneDrive/Área de Trabalho/2019_viagem.csv",
  sep = ';',
  dec = ','
)

# verificando se os dados foram carregados corretamente
# essa função apresenta apenas as primeiras linhas do dataset.
head(viagens)

# apresenta uma melhor tabela e possibilita verificar 
# se os dados foram carregados corretamente.
View(viagens)

# para verificar o numero de observações e colunas do dataset.
dim(viagens)

# recuperando algumas informações do dataset, como valor, maximo 
# e media das viagens a serviço.
?summary  # consultar documentação

summary(viagens)

summary(viagens$Valor.passagens)

# verificar o ipo dos dados de cada coluna.
install.packages("dplyr")
library(dplyr)

glimpse(viagens)

?as.Date
# para converter um campo para o tipo data
viagens$data.inicio <- as.Date(viagens$Período...Data.de.início,
                               "%d/%m/%y")
glimpse(viagens)

# formatar o campo data para trabalhar apenas com o mês e o ano.
viagens$data.inicio.formatada <- format(viagens$data.inicio, "%y-%m")

viagens$data.inicio.formatada

?format

# criar histograma
hist(viagens$Valor.passagens)

# valores min, max, média... da coluna valor
summary(viagens$Valor.passagens) # pecebe-se que o valor máximo está muito distante
                                 # da média, o que indica outliers

# OUTLIERS - são valores que fogem da normalidade dos dados, fazendo com que o 
# resultado de uma analise não reflita a realidade.

# visualizando os valores em um boxplot
boxplot(viagens$Valor.passagens)

# calculando o desvio padrão
sd(viagens$Valor.passagens)

?is.na # consultar documentação - usada para verificar se existem campos com valores não preenchidos.
?colSums # consultar documentação - contabiliza a quantidade de campos não preenchidos por coluna.

colSums(is.na(viagens))

# verificar a quantidade de ocorrencias para cada categoria de uma determinada coluna,
# a quantidade de ocorrencias para cada classe eo valor em percentual.

str(viagens$Situação)

table(viagens$Situação)

prop.table(table(viagens$Situação))*100

# respondendo as questões
# • Qual é o valor gasto por órgão?
# • Qual é o valor gasto por cidade?
# • Qual é a quantidade de viagens por mês?


# 1- Quais orgãos estão gastando mais com passagens aéreas?

# criando um data frame com os 15 orgão que gastam mais
p1 <- viagens %>%
  group_by(Nome.do.órgão.superior) %>% # agrupar o conj. de dados por nome do orgão superior.
  summarise(n = sum(Valor.passagens)) %>% # para somar o valor gasto em passagem por orgão.
  arrange(desc(n)) %>%  # ordena o resultado em ordem decrecente.
  top_n(15)  # lista os orgão que mais gastam com viagens.(filtra somente até o 15º resultado)

names(p1) <- ("orgao","valor") # para renomear as colunas, atribui um vetor com os novos valores.

p1

# Plotando os dados

ggplot(p1,aes(x= reorder(orgao,valor),y= valor))+ # reorder - ordena os valores do eixo x.
  geom_bar(stat ="identity")+ # defini que o gráfico terá a forma geometrica de barras.
  coord_flip()+               # possibilita mudar a orientação do grafico.
  labs(x="valor",y="Órgãos")  # serve para editar os valores dos rotulos de cada eixo.


# descobrir o valor gasto com viagens por cidade.
p2 <- viagens %>%
  group_by(Destinos) %>%
  summarise(n = sum(Valor.passagens)) %>%
  arrange(desc(n)) %>%
  top_n(15)

names(p2) <- c('destino','valor')

# criando o grafico
ggplot(p2,aes(x= reorder(destino,valor),y= valor))+
  geom_bar(stat ="identity", fill = "#0ba791")+ # fill - altera a cor das barras
  geom_text(aes(label=valor), vjust=0.3, size=3)+ # um texto é inserido diretamente no grafico.
# label - insere um retangulo atrás do texto a fim de facilitar a leitura.
# vjust e size servem para alterar o tamanho e aposição dos rotulos das barras.
  coord_flip()+
  labs(x="Valor",y="Destino")
  
  options(scipen = 999)
  
  
# descobrir a quantidade de viagens realizadas por mês.
p3 <- viagens %>%
  group_by(data.inicio.formatada) %>%
  summarise(qtd = n_distinct(Identificador.do.processo.de.viagem)) +
# n_distinct()- quantidade de identificadores distintos das viagens.
# garante que uma viagem não seja contabilizada mais de uma vez.
head(p3)

# criar grafico
ggplot(p3, aes(x=data.inicio.formatada, y=qtd, group=1)) + # informamos os valores de x e y
  # x - recebe o valor da data de inicio, y - recebe quantidade.
  geom_line()+ # linhas definidas por pares
  geom_point() # gera grafico de dispersão transformando pares em pontos.

# R MARKDOWN - É UMA FERRAMENTA USADA PARA TRANSFORMAR AS ANALISES EM DOCUMENTOS
# RELATÓRIOS, APRESENTAÇÕES E DASHBOARDS DE ALTA QUALIDADE.

# visualização dos dados

install.packages("rmarkdown")
install.packages('tinytex')

tinytex::install_tinytex()

# apos a instalação, vamos acessar file, new file, R Markdown
# menu suspenso title - relatorio, pdf e ok
# aparece uma aba name realtorio.Rmd
# o documento no formato R Markdown consiste em blocos de codigo
# e blocos de texto utilizados para documentar a analise.
# para adicionar mais blocos de codigo, é necessário acessar o menu
# "insert", localizado à direita desta janela, e clicar na opção R.

# tem que colocar da seguinte forma:

# Teste  
...{r}
print("Teste") # inserir texto explicando a analise.
...
  
# PARA GERAR UM DOCUMENTO REFERENTE AO RELATORIO, É NECESSÁRIO SELECIONAR
# KNIT - LOCALIZADO À ESQUERDA DA JANELA, E CLICAR "KNIT TO PDF".



# Identificar pacientes com alta probabilidade de serem diagnosticados com diabetes, tendo, no
# mínimo, 75% de acurácia.

# CARREGANDO OS DADOS
diabetes <- read.csv(
  file = "C:/Users/rosil/OneDrive/Área de Trabalho/diabetes.csv"
)

head(diabetes)

# PREPARAR DADOS

?str # é a estrutura do data frame - verifica o tipo de coluna ou variavel.
str(diabetes)

#  para campos naõ preenchidos
colSums(is.na(diabetes))

# para retornar informações como: média, mediana, valor minimo e máximo
summary(diabetes$Insulin)
boxplot(diabetes$Insulin)

# ANALISE EXPLORATORIA
boxplot(diabetes)

hist(diabetes2$Pregnancies)
hist(diabetes2$Age)
hist(diabetes2$BMI)

install.packages("dplyr")
library(dplyr)

diabetes2 <- diabetes %>%
  filter(Insulin <= 250) # para remover valores.
boxplot(diabetes2$Insulin)

boxplot(diabetes2)

summary(diabetes2$Insulin)

# CONSTRUÇÃO DO MODELO

# MODELO PREDITIVO
# PRIMIRO É NECESSARIO, DIVIDIR OS DADOS EM TREINOS E TESTE.
#Divisão dos dados
install.packages("caTools") # 
library(caTools)

set.seed(123)
index = sample.split(diabetes2$Pregnancies, SplitRatio = .70) # INSERIR COLUNA DO DATASET EO PERCENTUAL DE DIVISÃO.

index

# criar novos conjuntos de dados
train = subset(diabetes2, index == TRUE)
test = subset(diabetes2, index == FALSE)

dim(diabetes2)
dim(train)
dim(test)

# os dados acima estão divididos em treino e teste
install.packages("caret")
install.packages("e1071")

library(caret)
library(e1071)

?caret::train

modelo <-train(
  outcome ~., data = train, method = "knn" # (train) inseri as variavel resposta, e as preditoras.
)
# Outcome variavel resposta.
# O caracter (.) serve para informar que queremos utilizar todas as demais colunas
# do datasets como variaveis preditoras.
# é possivel utilizar apenas algumas variaveis preditoras.
# Para isso, deve-se inform-a-las individualmente depois do caractere til.
# para o "data" deve -se inserir o dataset de treino.
# para o "method" deve-se inserir o algoritmo a ser urilizado, knn.

modelo$results
modelo$bestTune

# para testar outros valores de k, inserir um intervalo de valores para o parametro
# tuneGrid.

modelo2 <- train(
  Outcome ~., data = train.method = "knn",
   tuneGrid = expand.grid(k = c(1:20)))
modelo2$results


# para verificar o melhor valor de k.
modelo2$bestTune

plot(model2)

# é possivel criar outro modelo utilizando outro algoritmo.
# Naive Bayes

moelo3 <- train(
  Outcome ~., data = train, method = "naive_bayes")

modelo3$results
modelo3$bestTune


# agora que o modelo foi treinado, avaliar o desempenho com dados não usado
# na fase de treinamento, dados teste.

# avaliando o modelo
?predict

predições <- predict(modelo4, test)# retorna as previsões com base no modelo e os dados de teste.

prediçoes

# previsões geradas pelo modelo, comparar com os dados esperados do conjunto de dados
# de treino.
?caret::confusionMatrix
confusionMatrix(predicoes, test$Outcome)# calcular a diferença entre os valores
# previstos e os valores esperados.
# observar a accuracy do algoritmo.

# modelo criado e validado.
# criar um data frame com a mesma estrutura, simulado dados de um novo paciente.

# RELIZANDO PREDIÇÕES

novos.dados <- data.frame(
  pregnancies = c(3),
  Glucose = c(111.50),
  BloodPressure = c(70),
  SkinThinckness = c(20),
  Insulin = c(47.49),
  BMI = c(30.80),
  DiabetesPedigreefunction = c(0.34),
  Age = c(28)
)
novos.dados

previsao <- predict(modelo4,novos.dados)

resultado <- ifelse(previsao == 1, "positivo", "Negativo") # formatar o resultado
print(paste("Resultado:", resultado))

# VISUALIZAÇÃO DOS RESULTADOS.
write.csv(predicoes,'resultado.csv')# o arquivo é gerado na pasta do projeto.

# UTILIZAR A FERRAMENTA R MARKDOWN.
# Obtenção dos dados
...{r}

diabetes <- read.csv(
  file = "C:/Users/rosil/OneDrive/Área de Trabalho/diabetes.csv"
)

head(diabetes)

# PREPARAÇÃO DOS DADOS
...{r messagem=FALSE, warning=FALSE}# colocado corretamente conferido no curso.

diabetes$Outcome <- as.factor(diabetes$Outcome)

library(dplyr)

diabetes <- diabetes %>%
  filter(Insulin <= 250)
...

# para gerar em PDF, knit, localizado à esquerda desta janela, 










  
  
  
  
  
  
  
  
  
  
  
  
  































