# Industrial Machinery Anomaly Detection - MATLAB Implementation

Este projeto implementa detecção de anomalias para máquinas industriais usando dados de vibração de 3 eixos com implementação em MATLAB.

## 📁 Estrutura do Projeto

```
Detect Anomalies in Industrial Machinery/
├── MATLAB_Environment/             # Ambiente MATLAB completo
│   ├── src/                        # Scripts principais MATLAB
│   │   └── anomaly_detection_main.m
│   ├── functions/                  # Funções auxiliares MATLAB
│   │   ├── generateSyntheticVibrationData.m
│   │   ├── extractVibrationFeatures.m
│   │   ├── getFeatureNames.m
│   │   ├── splitData.m
│   │   ├── normalizeFeatures.m
│   │   ├── trainOneClassSVM.m
│   │   └── trainIsolationForest.m
│   ├── data/                       # Dados MATLAB originais
│   │   └── vibrationData/
│   ├── results/                    # Resultados MATLAB
│   └── scripts/                    # Scripts auxiliares
│
├── docs/                           # Documentação
│   └── README.md
├── assets/                         # Recursos visuais
└── 0_REFERENCES.txt               # Referências do projeto
```

## 🔬 Ambiente MATLAB

### Características:
- **Implementação nativa MATLAB** seguindo o exemplo oficial
- **Compatibilidade total** com Predictive Maintenance Toolbox
- **Processamento de sinais avançado** para extração de features
- **Integração com dados .mat originais**

### Uso:

```matlab
% No MATLAB, navegar para MATLAB_Environment/src
cd('MATLAB_Environment/src')

% Executar script principal
anomaly_detection_main
```

### Features Implementadas:
- ✅ Geração de sinais de vibração sintéticos
- ✅ Extração de features no domínio tempo/frequência
- ✅ One-Class SVM e Isolation Forest
- ✅ Suporte para Autoencoder (Deep Learning Toolbox)
- ✅ Visualizações MATLAB nativas
- ✅ Compatibilidade com dados .mat

## 🔧 Modelos Implementados

### 1. One-Class SVM
- **MATLAB**: fitcsvm com workaround para one-class

### 2. Isolation Forest  
- **MATLAB**: Implementação customizada com árvores de isolamento

### 3. Autoencoder
- **MATLAB**: Deep Learning Toolbox (se disponível)

## 📊 Features Extraídas

### Canal 1 (Vibração de Máquinas):
- Fator de Crista
- Curtose  
- RMS
- Desvio Padrão

### Canal 2 (Vibração de Rolamentos):
- Média
- RMS
- Assimetria
- Desvio Padrão

### Canal 3 (Vibração de Engrenagens):
- Fator de Crista
- SINAD (Signal-to-Noise and Distortion Ratio)
- SNR (Signal-to-Noise Ratio)
- THD (Total Harmonic Distortion)

## 🎯 Resultados Esperados

### Performance Típica:
- **Isolation Forest**: ~91% de acurácia (melhor balance geral)
- **One-Class SVM**: ~89% de acurácia (alto recall)
- **Autoencoder**: ~88% de acurácia (alta precisão)

## 🚀 Como Começar

### Para Usuários MATLAB:
1. Execute `anomaly_detection_main.m` no ambiente MATLAB
2. Customize funções em `/functions/` conforme necessário
3. Use dados .mat reais substituindo a geração sintética
4. Adapte para seus dados reais de vibração

## 📈 Próximos Passos

- [ ] Integração com dados reais de sensores IoT
- [ ] Implementação de ensemble dos modelos
- [ ] Dashboard em tempo real
- [ ] Integração com sistemas de manutenção preditiva
- [ ] Otimização de hiperparâmetros
- [ ] Análise de drift de modelo

## 📚 Referências

- <a href="https://www.mathworks.com/help/predmaint/ug/anomaly-detection-using-3-axis-vibration-data.html" target="_blank">MATLAB Predictive Maintenance Toolbox</a>

---

**Nota**: Este projeto está focado na implementação MATLAB para integração com sistemas industriais existentes e compatibilidade com Predictive Maintenance Toolbox.