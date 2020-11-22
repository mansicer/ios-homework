from onnx_coreml import convert
from coremltools.models import MLModel

class_labels = ['air plane', 'automobile', 'bird', 'cat', 'deer', 'dog', 'frog', 'horse', 'ship', 'truck']
model = convert(model='convnet.onnx', minimum_ios_deployment_target='13', image_input_names=['image'], mode='classifier', 
    predicted_feature_name='classLabel', class_labels=class_labels)
model.save('Cifar10ConvNet.mlmodel')
