#!/bin/bash

show_ascii_art() {
    echo -e "\n\033[1;36m"  # 设置为青色
    cat << "EOF"
 ____                                   __                        
/\  _`\                                /\ \                       
\ \ \L\_\     __    ___     ____    ___\ \ \/'\   __  __    ___   
 \ \ \L_L   /'__`\/' _ `\  /',__\  / __`\ \ , <  /\ \/\ \  / __`\ 
  \ \ \/, \/\  __//\ \/\ \/\__, `\/\ \L\ \ \ \\`\\ \ \_\ \/\ \L\ \
   \ \____/\ \____\ \_\ \_\/\____/\ \____/\ \_\ \_\/`____ \ \____/
    \/___/  \/____/\/_/\/_/\/___/  \/___/  \/_/\/_/`/___/> \/___/ 
                                                      /\___/      
                                                      \/__/        
EOF
    echo -e "\033[0m"  # 恢复默认颜色
}

# 主菜单
main_menu() {
    clear
    show_ascii_art
    echo "========================"
    echo "1. 融合怪测评脚本"
    echo "2. IP质量体检脚本"
    echo "3. 节点搭建"
    echo "4. 退出"
    echo "========================"
}

sub_menu1() {
    while true; do
        clear
        echo "========================"
        echo "     融合怪测评脚本"
        echo "     (spiritLHLS/ecs)"
        echo "========================"
        echo "1. 融合怪Shell版本"
        echo "2. 融合怪测评项目 - GO 重构版本"
        echo "3. 融合怪测评项目 - GO 重构版本(国内加速)"
        echo "4. 返回主菜单"
        echo "========================"
        
        read -p "请选择操作 [1-4]: " sub_choice
        case $sub_choice in
            1)
                curl -L https://gitlab.com/spiritysdx/za/-/raw/main/ecs.sh -o ecs.sh
                chmod +x ecs.sh
                ./ecs.sh
                ;;
            2)
                export noninteractive=true
                curl -L https://raw.githubusercontent.com/oneclickvirt/ecs/master/goecs.sh -o goecs.sh
                chmod +x goecs.sh
                bash goecs.sh env
                bash goecs.sh install
                goecs
                ;;
            3)
                export noninteractive=true
                curl -L https://cdn.spiritlhl.net/https://raw.githubusercontent.com/oneclickvirt/ecs/master/goecs.sh -o goecs.sh
                chmod +x goecs.sh
                bash goecs.sh env
                bash goecs.sh install
                goecs
                ;;
            4)
                return  # 返回主菜单
                ;;
            *)
                echo "无效选项，请重新输入"
                ;;
        esac
        read -n 1 -s -r -p "按任意键继续..."
    done
}

sub_menu2() {
    while true; do
        clear
        echo "========================"
        echo "     IP质量体检脚本"
        echo "     (xykt/IPQuality)"
        echo "========================"
        echo "1. 双栈检测"
        echo "2. 只检测IPv4结果"
        echo "3. 只检测IPv6结果"
        echo "4. 返回主菜单"
        echo "========================"
        
        read -p "请选择操作 [1-4]: " sub_choice
        case $sub_choice in
            1)
                bash <(curl -Ls IP.Check.Place)
                ;;
            2)
                bash <(curl -Ls IP.Check.Place) -4
                ;;
            3)
                bash <(curl -Ls IP.Check.Place) -6
                ;;                
            4)
                return
                ;;
            *)
                echo "无效选项，请重新输入"
                ;;
        esac
        read -n 1 -s -r -p "按任意键继续..."
    done
}

sub_menu3() {
    while true; do
        clear
        echo "========================"
        echo "     节点搭建工具"
        echo "========================"
        echo "1. 官方XrayR"
        echo "2. wyx2682修改版XrayR"
        echo "3. wyx2682修改版V2bX"
        echo "4. Warp一键脚本"
        echo "5. 返回主菜单"
        echo "========================"
        
        read -p "请选择操作 [1-5]: " sub_choice
        case $sub_choice in
            1)
                bash <(curl -Ls https://raw.githubusercontent.com/XrayR-project/XrayR-release/master/install.sh)
                ;;
            2)
                bash <(curl -Ls https://raw.githubusercontent.com/wyx2685/XrayR-release/master/install.sh)
                ;;
            3)
                wget -N https://raw.githubusercontent.com/wyx2685/V2bX-script/master/install.sh
                bash install.sh
                ;;
            4)
                wget -N https://gitlab.com/fscarmen/warp/-/raw/main/menu.sh
                bash menu.sh
                ;;
            5)
                return
                ;;
            *)
                echo "无效选项，请重新输入"
                ;;
        esac
        read -n 1 -s -r -p "按任意键继续..."
    done
}

# 主程序循环
while true; do
    main_menu
    read -p "请选择主菜单 [1-4]: " main_choice
    
    case $main_choice in
        1)
            sub_menu1
            ;;
        2)
            sub_menu2
            ;;
        3)
            sub_menu3
            ;;
        4)
            echo "程序退出"
            exit 0
            ;;
        *)
            echo "无效选项，请重新输入"
            read -n 1 -s -r -p "按任意键继续..."
            ;;
    esac
done
