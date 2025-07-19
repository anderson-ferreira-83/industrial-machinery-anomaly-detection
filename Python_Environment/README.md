# Python Environment - Anomaly Detection

Este diretório contém a implementação Python completa para detecção de anomalias em máquinas industriais.

## 🚀 Início Rápido

```bash
# Instalar dependências
pip install -r requirements/requirements.txt

# Executar pipeline completo
python src/vibration_anomaly_detection.py

# Ou usar Jupyter Notebook (recomendado)
jupyter lab notebooks/vibration_anomaly_detection.ipynb
```

## 📁 Estrutura

- **`src/`**: Código fonte Python
- **`notebooks/`**: Jupyter Notebooks interativos  
- **`data/`**: Dados para análise
- **`models/`**: Modelos treinados salvos
- **`results/`**: Resultados e visualizações
- **`requirements/`**: Dependências do projeto
- **`tests/`**: Testes unitários

## 🔧 Dependências Principais

- **NumPy & Pandas**: Manipulação de dados
- **Scikit-learn**: Machine learning
- **TensorFlow**: Deep learning (Autoencoder)
- **Matplotlib & Seaborn**: Visualizações
- **Jupyter**: Notebooks interativos

## 📊 Modelos Implementados

1. **One-Class SVM** (scikit-learn)
2. **Isolation Forest** (scikit-learn)  
3. **Autoencoder** (TensorFlow/Keras)

## 🎯 Uso Recomendado

**Para exploração interativa**: Use o Jupyter Notebook
**Para automação**: Use o script Python principal