#!/usr/bin/python3

import os

# 图片字节头信息，
# [0][1]为jpg头信息，
# [2][3]为png头信息，
# [4][5]为gif头信息
pic_head = [0xff, 0xd8, 0x89, 0x50, 0x47, 0x49]


def get_code(file_path):
    """
    自动判断文件类型，并获取dat文件解密码
    :param file_path: dat文件路径
    :return: 如果文件为jpg/png/gif格式，则返回解密码，否则返回0
    """
    dat_file = open(file_path, "rb")
    dat_read = dat_file.read(2)

    # 解密码
    ext = ''
    head_index = 0
    while head_index < len(pic_head):
        # 使用第一个头信息字节来计算加密码
        # 第二个字节来验证解密码是否正确
        code = dat_read[0] ^ pic_head[head_index]
        idf_code = dat_read[1] ^ code

        head_index = head_index + 1
        if idf_code == pic_head[head_index]:
            dat_file.close()

            if head_index == 1:
                ext = '.jpg'
            if head_index == 3:
                ext = '.png'
            if head_index == 5:
                ext = '.gif'

            return code, ext

        head_index = head_index + 1

    print(file_path + u" - not jpg, png, gif")
    return 0, 0



def decode_dat(file_path, name, dir):
    """
    解密文件，并生成图片
    :param file_path: dat文件路径
    :return: 无
    """
    decode_code, ext = get_code(file_path)

    if (decode_code == 0):
        pass

    else:
        pic_name = dir + '/' + name + ext

        dat_file = open(file_path, "rb")
        pic_write = open(pic_name, "wb")

        for dat_data in dat_file:
            for dat_byte in dat_data:
                pic_data = dat_byte ^ decode_code
                pic_write.write(bytes([pic_data]))

        print(pic_name + u", 完成")

        dat_file.close()
        pic_write.close()


def find_datfile(dir_path):
    """
    获取dat文件目录下所有的文件
    :param dir_path: dat文件目录
    :return: 无
    """
    try:
        files_list = os.listdir(dir_path)


    except:
        print(u"没有那个目录")
        return 0

    for file_name in files_list:
        file_path = dir_path + "/" + file_name

        if os.path.isdir(file_path):
            find_datfile(file_path)

        else:
            name, ext = os.path.splitext(file_name)
            decode_dat(file_path, name, dir_path)

    return 0



path = input(u"请输入需要解密微信dat文件的目录:")
find_datfile(path)
