# 深度学习模型训练

本次作业中利用PyTorch框架完成了一个CIFAR10数据集上的简单卷积神经网络设计, 包含了3个卷积层以及2个全连接层, 使用了BatchNorm, Dropout等模块, 共计训练50个epoch, 最终在验证集上的准确率在0.75左右.

模型导出为了CoreML可以使用的mlmodel格式, 文件为`Cifar10ConvNet.mlmodel`.

### Installation

项目的Python依赖库在`requirements.txt`文件中.

```
conda create -n coreml python=3.7 -y
pip install -r requirements.txt
```
