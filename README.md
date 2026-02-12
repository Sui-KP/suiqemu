# SuiQemu<span style="float:right; font-size:0.5em; font-weight:normal; margin-top:1em;">QEMU for Android</span>
版本 1.5.202502121700
## 📖项目部署
1.启动Termux(以Google Play版为准)

2.下载suiqemu.sh并`chmod +x ./suiqemu.sh`

3.输入`./suiqemu.sh`即可获取帮助

```
用法: $0 [指令] [选项]
make                编译全部架构
make --target-list= 编译指定架构
continue            恢复中断构建
package             打包编译产物
```
4.回车默认不打包,若打包则最终产物在`{HOME}/suiqemu`文件夹

5.打包默认不包含BIOS等固件,可`suiqemu-{版本号}`源码目录执行
```
git sparse-checkout set pc-bios
```
获取必要固件

6.一些仿真架构可能会提示`Illegal Instruction`(非法指令),暂无解
## 📢项目来历
**在Android编译QEMU很难吗?<br>
不难。**<br>
但为什么全网搜出来的教程:<br>
随便点开一个,[**VIP**可查看]:明明就是很基础的源码改动,几行命令即可解决,为什么要坑小白?<br>
随便点开一个,[**QEMU 5.x**编译教程]:几辈子前的老古董了?此一时,彼一时,拿10年前的经验套现在的版本,不报错?想得美!<br>
更有甚者,拿AI灌水,全网抄袭,张嘴闭嘴把Linux编译逻辑硬往Android生搬硬套,也不管两者底层有什么不同,看似逻辑满分,一跑满屏红字;要么就是交叉编译,又是NDK又是GCC,结果稍不留神安装错架构Linux系统崩溃了;全然忘却多数Android设备本身就是AArch64,Termux完全可以拿下,结果AI说手机内存小储存不够速度慢!都什么年代了,你当手机性能还像当年那样性能孱弱不堪吗!<br>
### 我看不下去了。
我们凭什么就活该被割韭菜😡?!凭什么就得扫码进群😡?!凭什么就得给关注😡?!QEMU明明是完全开源免费的项目,应凝聚众智,岂有倒买倒卖之理!
## 🌟项目特色
<table width="100%">
  <thead>
    <tr>
      <th width="10%" align="center">对比</th>
      <th width="45%" align="left">🚀SuiQemu</th>
      <th width="45%" align="left">网络教程</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td align="center"><b>获取门槛</b></td>
      <td><b>✅不Star<br>✅不关注<br>✅不进群<br>✅仓库自取</b></td>
      <td>关注<br>进群<br>付费<br>求爷爷告奶奶</td>
    </tr>
    <tr>
      <td align="center"><b>代码逻辑</b></td>
      <td><b>✅代码开源<br>✅逻辑透明</b></td>
      <td>混淆缩写<br>加密打包<br>生怕看懂</td>
    </tr>
    <tr>
      <td align="center"><b>开源协议</b></td>
      <td><b>✅GPL开源协议</b></td>
      <td>无协议</td>
    </tr>
    <tr>
      <td align="center"><b>编译环境</b></td>
      <td><b>⚡原生环境<br>⚡稳定高速</b></td>
      <td>交叉编译<br>动辄报错</td>
    </tr>
    <tr>
      <td align="center"><b>实际体验</b></td>
      <td>
        <b>
          ✅支持超多架构<br>
          ✅编译方式灵活<br>
          ✅支持断点续编<br>
          ✅支持移植打包<br>
          ✅命令实用帮助<br>
          ✅用户界面简约<br>
          ✅步骤清晰明了<br>
          ✅自检逻辑成熟<br>
          🥰精彩等你发现
        </b>
      </td>
      <td>无交互</td>
    </tr>
  </tbody>
</table>
