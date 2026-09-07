import torch
from torch import nn

torch.manual_seed(20260907)
x = torch.linspace(-1, 1, 101).reshape(-1, 1)
y = 3 * x - 1
model = nn.Linear(1, 1)
loss_fn = nn.MSELoss()
opt = torch.optim.SGD(model.parameters(), lr=0.1)

for _ in range(200):
      pred = model(x)
      loss = loss_fn(pred, y)
      opt.zero_grad()
      loss.backward()
      opt.step()

model.eval()
with torch.no_grad():
      pred = model(x)
      loss = loss_fn(pred, y)
      print(f"final loss: {loss.item():.6f}")
      print(f"weight: {model.weight.item():.4f}")
      print(f"bias: {model.bias.item():.4f}")