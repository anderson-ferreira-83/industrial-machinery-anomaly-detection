# Industrial Machinery Anomaly Detection - Dual Environment Setup

Este projeto implementa detecção de anomalias para máquinas industriais usando dados de vibração de 3 eixos, disponível em **duas implementações paralelas**: Python e MATLAB.

## 📁 Estrutura do Projeto

```
3_Detect Anomalies in Industrial Machinery/
├── Python_Environment/              # Ambiente Python completo
│   ├── src/                        # Código fonte Python
│   │   ├── vibration_anomaly_detection.py
│   │   ├── examine_data.py
│   │   └── extract_matlab_data.py
│   ├── notebooks/                  # Jupyter Notebooks
│   │   └── vibration_anomaly_detection.ipynb
│   ├── data/                       # Dados para Python
│   ├── models/                     # Modelos salvos
│   ├── results/                    # Resultados Python
│   ├── requirements/               # Dependências
│   │   └── requirements.txt
│   └── tests/                      # Testes unitários
│
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

## 🐍 Ambiente Python

### Características:
- **Implementação moderna** com scikit-learn e TensorFlow
- **Jupyter Notebook interativo** com visualizações avançadas
- **Três modelos**: One-Class SVM, Isolation Forest, Autoencoder
- **Dados sintéticos** que simulam padrões reais de vibração

### Instalação e Uso:

```bash
# Navegar para o ambiente Python
cd Python_Environment

# Instalar dependências
pip install -r requirements/requirements.txt

# Executar script principal
python src/vibration_anomaly_detection.py

# Ou usar o Jupyter Notebook
jupyter lab notebooks/vibration_anomaly_detection.ipynb
```

### Features Implementadas:
- ✅ Geração de dados sintéticos realistas
- ✅ Extração de 12 features por amostra (4 por canal)
- ✅ Três algoritmos de detecção de anomalias
- ✅ Avaliação completa com métricas
- ✅ Visualizações interativas
- ✅ Salvamento de modelos e resultados

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
- **Python**: scikit-learn com kernel RBF
- **MATLAB**: fitcsvm com workaround para one-class

### 2. Isolation Forest  
- **Python**: scikit-learn nativo
- **MATLAB**: Implementação customizada com árvores de isolamento

### 3. Autoencoder
- **Python**: TensorFlow/Keras com arquitetura personalizada
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

### Para Usuários Python:
1. Use o **Jupyter Notebook** para exploração interativa
2. Execute `vibration_anomaly_detection.py` para pipeline completo
3. Modifique parâmetros no notebook para experimentação

### Para Usuários MATLAB:
1. Execute `anomaly_detection_main.m` no ambiente MATLAB
2. Customize funções em `/functions/` conforme necessário
3. Use dados .mat reais substituindo a geração sintética

### Para Ambos os Ambientes:
1. Compare resultados entre Python e MATLAB
2. Use o ambiente que melhor se adequa ao seu workflow
3. Adapte para seus dados reais de vibração

## 📈 Próximos Passos

- [ ] Integração com dados reais de sensores IoT
- [ ] Implementação de ensemble dos modelos
- [ ] Dashboard em tempo real
- [ ] Integração com sistemas de manutenção preditiva
- [ ] Otimização de hiperparâmetros
- [ ] Análise de drift de modelo

## 📚 Referências

- [MATLAB Predictive Maintenance Toolbox](https://www.mathworks.com/help/predmaint/ug/anomaly-detection-using-3-axis-vibration-data.html)
- [Scikit-learn Anomaly Detection](https://scikit-learn.org/stable/modules/outlier_detection.html)
- [TensorFlow Autoencoders](https://www.tensorflow.org/tutorials/generative/autoencoder)

---

**Nota**: Os dois ambientes são funcionalmente equivalentes mas otimizados para diferentes workflows. Use Python para prototipagem rápida e MATLAB para integração com sistemas existentes.