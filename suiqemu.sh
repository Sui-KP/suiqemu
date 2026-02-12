#!/bin/bash
RED='\033[0;31m'
YELLOW='\033[0;33m'
GREEN='\033[0;32m'
NC='\033[0m'
TARGET_LIST_DEFAULT="aarch64-softmmu,alpha-softmmu,arm-softmmu,avr-softmmu,hppa-softmmu,i386-softmmu,loongarch64-softmmu,m68k-softmmu,microblaze-softmmu,microblazeel-softmmu,mips-softmmu,mips64-softmmu,mips64el-softmmu,mipsel-softmmu,or1k-softmmu,ppc-softmmu,ppc64-softmmu,riscv32-softmmu,riscv64-softmmu,rx-softmmu,s390x-softmmu,sh4-softmmu,sh4eb-softmmu,sparc-softmmu,sparc64-softmmu,tricore-softmmu,x86_64-softmmu,xtensa-softmmu,xtensaeb-softmmu"
OUTOFF=false
for arg in "$@"; do
if [[ "$arg" == "--outoff" ]]; then
OUTOFF=true
fi
done
if [[ -f .last_dir ]]; then
LAST_DIR=$(cat .last_dir)
fi
ee() {
local msg="$1"
[[ "$msg" == "---div---" ]] && msg=$(printf '%.0s─' $(seq 1 ${COLUMNS:-80}))
case "$msg" in
🔴*) echo -e "${RED}${msg#🔴}${NC}" ;;
🟡*) echo -e "${YELLOW}${msg#🟡}${NC}" ;;
🟢*) echo -e "${GREEN}${msg#🟢}${NC}" ;;
*) echo -e "$msg" ;;
esac
}
run() {
if [[ "$OUTOFF" == true ]]; then
script -q -c "$*" /dev/null >/dev/null 2>&1
else
script -q -c "$*" /dev/null
fi
}
tui(){ local title="" pgb=false
while [[ "$#" -gt 0 ]];do case "$1" in --title)title=" $2 ";shift 2;;--pgb)pgb=true;shift;;*)break;;esac;done
export COLUMNS TUI_CMD="$*"
python3 -c "import sys,subprocess,re,shutil,os,time,fcntl
def run():
 pgb='$pgb'=='true';cmd=os.environ.get('TUI_CMD','');ui_title='$title'.strip();proc=subprocess.Popen(cmd,shell=True,stdout=subprocess.PIPE,stderr=subprocess.STDOUT,bufsize=0,executable='/data/data/com.termux/files/usr/bin/bash');fd=proc.stdout.fileno();fcntl.fcntl(fd,fcntl.F_SETFL,fcntl.fcntl(fd,fcntl.F_GETFL)|os.O_NONBLOCK);orig_fl=fcntl.fcntl(0,fcntl.F_GETFL);fcntl.fcntl(0,fcntl.F_SETFL,orig_fl|os.O_NONBLOCK);logs,c_step,t_step,last_pgb_t,tw,th,anim_off,is_min=[],0,1,0,0,0,0.0,False;stdout=sys.stdout.buffer;write,flush=stdout.write,stdout.flush;write(b'\033[?25l');raw_buf=b''
 while True:
  t_start=time.perf_counter();redraw=False
  try:
   u=sys.stdin.read(1)
   if u=='d':is_min,redraw=True,True
   elif u=='u':is_min,redraw=False,True
   elif u=='c':proc.terminate();break
  except:pass
  while True:
   try:
    chunk=proc.stdout.read(16384)
    if not chunk:break
    raw_buf+=chunk
   except:break
  if raw_buf:
   parts=raw_buf.split(b'\n')
   if len(parts)>1:
    for p in parts[:-1]:
     txt=p.decode('utf-8','ignore').strip()
     m=re.search(r'\[(\d+)/(\d+)\]',txt)
     if pgb and m:c_step,t_step=int(m.group(1)),int(m.group(2))
     elif txt:logs.append(txt);redraw=True
    raw_buf=parts[-1]
  nw,nh=shutil.get_terminal_size()
  if(nw,nh)!=(tw,th):tw,th,redraw=nw,nh,True
  if redraw:
   out=[b'\033[H\033[2J']
   if is_min:out.append(f'\033[{th};1H\033[7m {ui_title if ui_title else \"TUI\"} [已最小化] \033[0m'.encode())
   else:
    tp=(tw-len(ui_title))//2;ctrl,ctrl_w='🔴🟡🟢╮',7;hdr_l=f'\033[1;1H╭{\"─\"*(tp-2)}{ui_title}';out.append(hdr_l.encode());l_used=1+(tp-2)+len(ui_title);remain=(tw-ctrl_w+1)-l_used
    if remain>0:out.append(f'{\"─\"*remain}'.encode())
    out.append(f'\033[1;{tw-ctrl_w+1}H{ctrl}'.encode())
    for i in range(2,th):out.append(f'\033[{i};1H│\033[{i};{tw}H│'.encode())
    out.append(f'\033[{th};1H╰{\"─\"*(tw-2)}╯'.encode());ls=3 if pgb else 2;mh=max(0,th-ls)
    for i,l in enumerate(logs[-mh:]):out.append(f'\033[{ls+i};2H{l[:tw-2]:<{tw-2}}'.encode())
   write(b''.join(out));flush()
  if not is_min and pgb:
   now=time.perf_counter();delta=(now-last_pgb_t)if last_pgb_t>0 else 0;last_pgb_t,anim_off=now,anim_off+delta*60;bl=tw-2;fill=c_step*bl//t_step
   if fill>=0:
    pos=(int(anim_off)%(fill+6))-3;pb=f'\033[42m{\" \"*max(0,min(pos,fill))}\033[102m{\" \"*max(0,min(pos+3,fill)-max(0,pos))}\033[42m{\" \"*max(0,fill-max(0,pos+3))}'
    write(f'\033[s\033[2;2H{pb}\033[100m{\" \"*(bl-fill)}\033[0m\033[u'.encode());flush()
  if proc.poll()is not None and not raw_buf:break
  time.sleep(max(0,0.0111-(time.perf_counter()-t_start)))
 proc.stdout.close();write(b'\033[?25h\033[r\033[2J\033[H');flush();fcntl.fcntl(0,fcntl.F_SETFL,orig_fl);sys.exit(proc.returncode)
try:run()
except:
 try:import fcntl;fcntl.fcntl(0,fcntl.F_SETFL,0)
 except:pass
 os._exit(0)"
}
validate_targets() {
local input="$1"
if [[ "$input" == "all" || -z "$input" ]]; then
return 0
fi
IFS=',' read -ra addr <<< "$input"
for target in "${addr[@]}"; do
if [[ ! ",$TARGET_LIST_DEFAULT," == *",$target,"* ]]; then
exit 1
fi
done
}
check_and_install() {
ee "🟡检查组件"
local to_install=()
for pkg in "$@"; do
local info=$(apt list --installed "$pkg" 2>/dev/null | grep "installed")
if [[ -n "$info" ]]; then
ee "🟢$info"
else
ee "🔴$pkg"
to_install+=("$pkg")
fi
done
if [[ ${#to_install[@]} -gt 0 ]]; then
ee "🟡安装组件"
apt-get install -y "${to_install[@]}"
fi
}
select_source() {
local dirs=($(ls -d suiqemu-* 2>/dev/null))
local latest_ver=$(curl -sSL https://gitlab.com/qemu-project/qemu/-/raw/cd5a79dc98e3087e7658e643bdbbb0baec77ac8a/VERSION | tr -d '\r\n')
if [[ ${#dirs[@]} -eq 0 ]]; then
SOURCE_DIR="suiqemu-$latest_ver"
return 1
fi
echo "0.官仓最新($latest_ver)"
for i in "${!dirs[@]}"; do
echo "$((i+1)). ${dirs[i]}"
done
read -p "🟢选择源码目录:" choice
if [[ -z "$choice" || "$choice" == "0" ]]; then
SOURCE_DIR="suiqemu-$latest_ver"
return 1
fi
SOURCE_DIR="${dirs[choice-1]}"
return 0
}
bundle() {
local targets="$1"
[[ "$targets" == "all" ]] && targets=""
local ver=$(cat ../VERSION 2>/dev/null || echo "unknown")
echo -e "\n压缩等级\n0存储\n1标准\n2最小"
read -p "🟢输入选项[0-2]" pkg_mode
local xz_cmd="xz -0"
[[ "$pkg_mode" == "1" ]] && xz_cmd="xz -6"
[[ "$pkg_mode" == "2" ]] && xz_cmd="xz -9e -T0"
mkdir -p ../../suiqemu
local raw_bins=$(find . -maxdepth 1 -type f -name "qemu-system-*" ! -name "*.*")
local bins_to_pack=()
for bin in $raw_bins; do
local arch=${bin#./qemu-system-}
if [[ -z "$targets" || "$targets" == *"$arch"* ]]; then
bins_to_pack+=("$bin")
fi
done
local total=${#bins_to_pack[@]}
[[ $total -eq 0 ]] && { echo "❌ 未找到匹配文件"; return 1; }
local bins_str="${bins_to_pack[*]}"
local cmd_logic="count=0; for bin_path in $bins_str; do ((count++)); arch=\${bin_path#./qemu-system-}; echo \"[\$count/$total] 正在封装 \$arch...\"; strip -s \"\$bin_path\"; tmp=\"temp_pkg_\$arch\"; mkdir -p \"\$tmp\"; cp \"\$bin_path\" \"\$tmp/\"; ldd \"\$(readlink -f \"\$bin_path\")\" | grep \"/data/data/com.termux\" | awk -F '=> ' '{print \$2}' | awk '{print \$1}' | sort -u | xargs -I {} cp -L {} \"\$tmp/\"; printf '#!/bin/sh\nR=\$(cd \"\$(dirname \"\$0\")\"; pwd)\nexport LD_LIBRARY_PATH=\"\$R:\$LD_LIBRARY_PATH\"\nexec \"\$R/%s\" \"\$@\"\n' \"\$(basename \"\$bin_path\")\" > \"\$tmp/qemu.sh\"; chmod +x \"\$tmp/qemu.sh\"; out_name=\"suiqemu-\$(uname -m)-$ver-\$arch.tar.xz\"; tar -C \"\$tmp\" -cf - . | $xz_cmd > \"../../suiqemu/\$out_name\"; rm -rf \"\$tmp\"; done; echo \"🟢 完成\""
tui --title "SuiQemu Bundler" --pgb "$cmd_logic"
}
do_make() {
validate_targets "$1"
select_source
local existed=$?
ee "🟡刷新软件源"
run pkg update -y
check_and_install x11-repo
check_and_install binutils git python ninja cmake glib libpixman libandroid-shmem-static libiconv ndk-sysroot clang pkg-config llvm xz-utils curl libslirp libusb pulseaudio libjpeg-turbo libpng libcap-ng libssh libxml2 virglrenderer xorgproto libx11 zstd liblzo libnettle libsnappy ncurses libspice-server dtc libbz2 libgnutls libgcrypt sdl2 libdecor libxcursor libxkbcommon libxrandr libxss libepoxy mesa capstone mesa-dev libdrm flex bison libvte sdl2-image
ee "🟡部署meson"
run pip install meson
if pkg-config --exists "libusbredirparser-0.5" || pkg-config --exists "libusbredirhost"; then
ee "🟢组件usbredir就绪"
else
ee "🟡构建usbredir"
cd && rm -rf usbredir
run git clone https://gitlab.freedesktop.org/spice/usbredir.git
cd usbredir && mkdir build && cd build
run meson setup --prefix=$PREFIX --buildtype=release ..
run ninja install
cd
fi
if [[ $existed -eq 1 ]]; then
ee "🟡克隆QEMU官方仓库"
rm -rf "$SOURCE_DIR"
run git clone --depth 1 --single-branch https://gitlab.com/qemu-project/qemu.git "$SOURCE_DIR"
fi
cd "$SOURCE_DIR"
pwd > ../.last_dir
ee "🟡应用补丁"
echo "补丁版本1.2.0_20260209"
sed -i 's/shm_open(/open(/g' util/oslib-posix.c
sed -i 's/shm_unlink(/unlink(/g' util/oslib-posix.c
sed -i '/ret = close_range(first, last, 0);/c\ret = -1; errno = ENOSYS;' util/oslib-posix.c
sed -i '1i #include <sys/stat.h>\n#undef st_atime_nsec\n#undef st_mtime_nsec\n#undef st_ctime_nsec' fsdev/9p-marshal.h
sed -i ':a;N;$!ba;s/ssize_t ret = copy_file_range[^;]*;/ssize_t ret = -1; errno = ENOSYS;/g' block/file-posix.c
sed -i ':a;N;$!ba;s/ret = copy_file_range[^;]*;/ret = -1; errno = ENOSYS;/g' block/file-posix.c
sed -i 's/ssize_t ret = -1;[[:space:]]*ssize_t ret = -1;/ssize_t ret = -1;/g' block/file-posix.c
echo "# disabled" > tests/meson.build
export AR=$(which llvm-ar) RANLIB=$(which llvm-ranlib) NM=$(which llvm-nm)
mkdir -p build && cd build
rm -rf *
local final_args="${1:-$TARGET_LIST_DEFAULT}"
if [[ "$final_args" == "all" ]]; then
final_args=$TARGET_LIST_DEFAULT
fi
ee "🟡部署编译[架构列表:$final_args]"
run ../configure --target-list=$final_args --enable-kvm --enable-vnc --enable-pie --enable-slirp --enable-libusb --enable-usb-redir --enable-virtfs --audio-drv-list=pa --enable-png --enable-virglrenderer --disable-werror --disable-install-blobs --disable-tools --disable-guest-agent --disable-vhost-user --enable-coroutine-pool --enable-malloc=system --extra-ldflags="-liconv -landroid-shmem"
ee "🟡启动Ninja编译引擎"
ninja --version
if tui --title "SuiQemu Installer" --pgb "ninja -j$(nproc)"; then
clear;ee "🟢编译成功"
read -p "🟡是否立即执行打包程序?(y/n):" is_pkg
[[ "$is_pkg" == [Yy]* ]] && bundle "$1" || ee "🟢完成"
else
ee "🔴编译失败";exit 1
fi
}
show_help(){
local div="---div---"
ee "$div"
ee "🟡使用手册"
ee "$div"
echo "用法: $0 [指令] [选项]
make                编译全部架构
make --target-list= 编译指定架构
continue            恢复中断构建
package             打包编译产物"
ee "$div"
ee "🟢当前支持的架构:"
ee "$div"
echo "$TARGET_LIST_DEFAULT" | tr ',' '\n' | while read -r line; do ee "🟢$line"; done
exit 1
}
clear
echo -e "${GREEN}SuiQemu\nAndroid $(uname -m)${NC}"
[[ $# -eq 0 ]] && show_help
arg="${2#--target-list=}"
case "$1" in
make) do_make "$arg" ;;
continue)
[[ ! -d "$LAST_DIR/build" ]] && exit 1
cd "$LAST_DIR/build"
ee "🟡恢复编译"
if tui --title "SuiQemu Installer" --pgb "ninja -j$(nproc)"; then
clear;ee "🟢编译成功"
read -p "🟡打包?(y/N):" is_pkg
[[ "$is_pkg" == [Yy]* ]] && bundle "" || ee "🟢完成"
else
ee "🔴编译失败";exit 1
fi ;;
package) [[ -d build ]] && cd build; bundle "$arg" ;;
*) show_help ;;
esac