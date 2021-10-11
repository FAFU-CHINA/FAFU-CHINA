import matplotlib.pyplot as plt
import imageio, os
from PIL import Image
GIF = []
filepath = "./png/"
files = os.listdir(filepath)

filenames = sorted(files, key=lambda x: int(x[:-4]))
for filename in filenames:
    GIF.append(imageio.imread(filepath+"\\"+filename))

imageio.mimsave("./"+'result.gif', GIF, duration=0.2)
