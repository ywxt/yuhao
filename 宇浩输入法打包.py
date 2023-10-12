# %%

from datetime import datetime
# version = datetime.today().strftime('%Y%m%d')
import shutil
import os
from distutils.dir_util import copy_tree
from distutils.dir_util import remove_tree

version = "v2.5.2"

#%%
try:
    remove_tree("./dist/yuhao")
except:
    pass

# remove_tree("./wafel")

#%%
os.makedirs("./dist/yuhao")
shutil.copyfile("./image/宇浩输入法宋体字根图v2olkb.png", f"./dist/yuhao/宇浩输入法宋体字根图{version}.png")
shutil.copyfile("./beta/readme.md", f"./dist/yuhao/readme.txt")
copy_tree("./beta/mabiao", "./dist/yuhao/mabiao")
copy_tree("./beta/schema", "./dist/yuhao/schema")
copy_tree("./beta/hotfix", "./dist/yuhao/hotfix")

shutil.make_archive(f"./dist/yuhao_{version}", 'zip', "./dist/yuhao")

# %%
# shutil.make_archive(f"./dist/yuhao_{version}_android_hotfix", 'zip', "./beta/hotfix")
# %%
