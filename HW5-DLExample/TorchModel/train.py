import torch as th
import torch.nn as nn
import torch.nn.functional as F
import torchvision.transforms as T
from torchvision.datasets import CIFAR10

transofrm = T.Compose([
    T.RandomRotation(5),
    T.RandomVerticalFlip(0.2),
    T.RandomHorizontalFlip(0.2),
    T.ToTensor(),
])
dataset_train = CIFAR10('./dataset', train=True, transform=transofrm, download=True)
dataset_test = CIFAR10('./dataset', train=False, transform=transofrm, download=True)
