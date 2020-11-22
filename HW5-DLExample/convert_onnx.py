import torch as th
from train import ConvNet

model = ConvNet()
model.load_state_dict(th.load('convnet_epoch50.pkl', map_location=th.device('cpu')))
dummy_input = th.rand(1, 3, 32, 32)
input_names = ['image']
output_names = ['classLabelProbs']
th.onnx.export(model, dummy_input, 'convnet.onnx', verbose=True, input_names=input_names, output_names=output_names)
