# MATLAB Environment - Anomaly Detection

Este diretório contém a implementação MATLAB completa para detecção de anomalias em máquinas industriais, seguindo o exemplo oficial do Predictive Maintenance Toolbox.

## 🚀 Início Rápido

```matlab
% No MATLAB, navegar para o diretório src
cd('src')

% Executar script principal
anomaly_detection_main
```

## 📁 Estrutura

- **`src/`**: Scripts principais MATLAB
- **`functions/`**: Funções auxiliares customizadas
- **`data/`**: Dados .mat originais do exemplo
- **`results/`**: Resultados e visualizações MATLAB
- **`scripts/`**: Scripts auxiliares e utilitários

## 🧰 Toolboxes Necessárias

- **Statistics and Machine Learning Toolbox**: SVM e Isolation Forest
- **Signal Processing Toolbox**: Análise de sinais de vibração
- **Deep Learning Toolbox**: Autoencoder (opcional)
- **Predictive Maintenance Toolbox**: Funcionalidades avançadas (opcional)

## 📊 Funcionalidades Principais

### Geração de Dados
- **`generateSyntheticVibrationData.m`**: Sinais sintéticos realistas
- Simulação de 3 canais com padrões normais e anômalos
- Modelagem de falhas típicas (desbalanceamento, desgaste, etc.)

### Extração de Features
- **`extractVibrationFeatures.m`**: 12 features por amostra
- Análise no domínio tempo e frequência
- Features específicas por canal conforme exemplo MATLAB

### Modelos de Anomalia
- **`trainOneClassSVM.m`**: One-Class SVM customizado
- **`trainIsolationForest.m`**: Implementação própria de Isolation Forest
- Suporte para Autoencoder (se Deep Learning Toolbox disponível)

## 🔧 Uso Avançado

### Personalização de Features
Modifique `extractVibrationFeatures.m` para adicionar suas próprias features:

```matlab
% Exemplo: adicionar feature personalizada
customFeature = calculateCustomFeature(signal);
features(i, featureIdx) = customFeature;
```

### Integração com Dados Reais
Substitua a geração sintética carregando seus dados .mat:

```matlab
% No lugar de generateSyntheticVibrationData()
load('seus_dados_reais.mat');
```

### Otimização de Parâmetros
Ajuste parâmetros nos arquivos de treinamento:

```matlab
% Em trainOneClassSVM.m
svmModel = fitcsvm(X_combined, y_combined, ...
                  'KernelFunction', 'gaussian', ...  % Mude kernel
                  'KernelScale', 2.0);               % Ajuste escala
```

## 📈 Resultados

Os resultados são salvos automaticamente em:
- **`results/matlab_anomaly_detection_results.png`**: Visualizações
- **`results/anomaly_detection_models.mat`**: Modelos treinados
- **`results/anomaly_detection_predictions.mat`**: Predições

## 🔍 Troubleshooting

### Toolbox não disponível
Se uma toolbox necessária não estiver disponível, o código usa fallbacks:
- **SVM**: Método estatístico com distância de Mahalanobis
- **Isolation Forest**: Detecção de outliers com regra 3-sigma

### Erro de memória
Para datasets grandes, ajuste os parâmetros:
```matlab
% Reduzir número de árvores no Isolation Forest
nTrees = 50;  % Padrão: 100

% Reduzir tamanho de subsample
subSampleSize = 128;  % Padrão: 256
```

## 🎯 Compatibilidade

- **MATLAB R2019b+**: Versão mínima recomendada
- **Versões anteriores**: Podem precisar de ajustes na sintaxe
- **Octave**: Compatibilidade limitada (algumas funções podem não funcionar)

## 📚 Referências MATLAB

- [Anomaly Detection Documentation](https://www.mathworks.com/help/predmaint/ug/anomaly-detection-using-3-axis-vibration-data.html)
- [One-Class SVM](https://www.mathworks.com/help/stats/fitcsvm.html)
- [Signal Processing](https://www.mathworks.com/help/signal/)
- [Deep Learning](https://www.mathworks.com/help/deeplearning/)