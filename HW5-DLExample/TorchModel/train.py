import torch as th
import torch.nn as nn
import torch.nn.functional as F
from torch.nn.modules.dropout import Dropout
import torchvision.transforms as T
from torch import optim
from torchvision.datasets import CIFAR10
from torch.utils.data import DataLoader
from tqdm import tqdm

BATCH_SIZE = 256
EPOCHS = 50

class ConvNet(nn.Module):
    def __init__(self) -> None:
        super(ConvNet, self).__init__()
        self.feature_extractor = nn.Sequential(
            nn.Conv2d(3, 32, 3, 1, 1),
            nn.BatchNorm2d(32),
            nn.ReLU(),
            nn.MaxPool2d(2), # 32, 16, 16
            nn.Conv2d(32, 64, 3, 1, 1),
            nn.BatchNorm2d(64),
            nn.ReLU(),
            nn.MaxPool2d(2), # 64, 8, 8
            nn.Conv2d(64, 64, 3, 1, 1),
            nn.BatchNorm2d(64),
            nn.ReLU(),
            nn.MaxPool2d(2), # 64, 4, 4
        )
        self.fc = nn.Sequential(
            Dropout(),
            nn.Linear(64*4*4, 512),
            nn.ReLU(),
            Dropout(),
            nn.Linear(512, 10),
        )
    
    def forward(self, x):
        B = x.shape[0]
        feature = self.feature_extractor(x)
        result = self.fc(feature.view(B, -1))
        return result


if __name__ == '__main__':
    transofrm = T.Compose([
        T.RandomRotation(5),
        T.RandomVerticalFlip(0.2),
        T.RandomHorizontalFlip(0.2),
        T.ToTensor(),
    ])

    dataset_train = CIFAR10('./dataset', train=True, transform=transofrm, download=True)
    dataset_val = CIFAR10('./dataset', train=False, transform=transofrm, download=True)
    loader_train = DataLoader(dataset_train, batch_size=BATCH_SIZE, shuffle=True, drop_last=True)
    loader_val = DataLoader(dataset_val, batch_size=BATCH_SIZE)

    device = th.device('cuda' if th.cuda.is_available() else 'cpu')
    model = ConvNet().to(device)
    criterioin = nn.CrossEntropyLoss()
    optimizer = optim.Adam(model.parameters())

    for epoch in range(1, EPOCHS + 1):
        print(f'Starting Epoch {epoch}')
        model.train()
        for img, label in tqdm(loader_train):
            img = img.to(device)
            label = label.to(device)
            optimizer.zero_grad()

            pred = model(img)
            loss = criterioin(pred, label)
            loss.backward()
            optimizer.step()
        
        model.eval()
        num_true, num_total = 0, 0
        with th.no_grad():
            for img, label in loader_val:
                img = img.to(device)
                label = label.to(device)
                pred = model(img)
                res = th.max(pred, dim=1)[1]
                num_true += th.sum(res == label).item()
                num_total += img.shape[0]
        print(f'Epoch {epoch} val accuracy {num_true/num_total:.4f}')

    th.save(model.state_dict(), f'./convnet_epoch{EPOCHS}.pkl')
