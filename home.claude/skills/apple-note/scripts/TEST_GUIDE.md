# Apple Notes Plugin 测试指南

## 步骤 1: 添加可执行权限

```bash
cd /Users/leetao/workspace/claude-local-plugins/apple-note-plugin/.claude-plugin/skills/apple-note/scripts
chmod +x *.sh
```

## 步骤 2: 测试读取操作（安全）

### 2.1 列出所有账户
```bash
./list-accounts.sh
```
预期输出: 类似 `iCloud` 或 `On My Mac` 或你的邮箱地址

### 2.2 列出文件夹
```bash
# 使用你的实际账户名
./list-folders.sh iCloud
```
预期输出: 文件夹列表，如 `Notes\n收件箱\n快速备忘`

### 2.3 列出备忘录
```bash
./list-notes.sh iCloud "Notes"
```
预期输出: 每行一个备忘录，格式为 `标题 | 日期 | 预览`

### 2.4 读取备忘录内容
```bash
# 使用一个实际存在的备忘录名称
./get-note.sh iCloud "Notes" "测试笔记"
```

### 2.5 搜索备忘录
```bash
./search-notes.sh iCloud "Notes" "关键词"
```

## 步骤 3: 测试写操作（谨慎）

### 3.1 创建测试备忘录
```bash
./create-note.sh iCloud "Notes" "Claude 测试笔记" "这是通过脚本创建的测试内容"
```

### 3.2 更新备忘录
```bash
# 先创建一个测试笔记
./create-note.sh iCloud "Notes" "更新测试" "原始内容"

# 然后更新它
./update-note.sh iCloud "Notes" "更新测试" "更新后的新内容<br>第二行"
```

## 步骤 4: 完整测试流程（自动化）

运行完整测试脚本：
```bash
cd /Users/leetao/workspace/claude-local-plugins/apple-note-plugin/.claude-plugin/skills/apple-note/scripts

# 1. 检查权限
ls -l *.sh

# 2. 测试账户列表
echo "=== 测试 1: 列出账户 ==="
./list-accounts.sh
echo ""

# 3. 测试文件夹列表
echo "=== 测试 2: 列出文件夹 ==="
./list-folders.sh iCloud
echo ""

# 4. 测试备忘录列表
echo "=== 测试 3: 列出备忘录 ==="
./list-notes.sh iCloud "Notes"
echo ""

# 5. 创建测试笔记
echo "=== 测试 4: 创建笔记 ==="
./create-note.sh iCloud "Notes" "Claude Test $(date +%s)" "测试内容<br>换行内容"
echo ""

# 6. 读取刚创建的笔记
echo "=== 测试 5: 读取笔记 ==="
./get-note.sh iCloud "Notes" "Claude Test"
echo ""

# 7. 搜索笔记
echo "=== 测试 6: 搜索笔记 ==="
./search-notes.sh iCloud "Notes" "Claude"
echo ""

# 8. 更新笔记
echo "=== 测试 7: 更新笔记 ==="
./update-note.sh iCloud "Notes" "Claude Test" "已更新的内容"
echo ""
```

## 步骤 5: 测试特殊字符（重要）

测试脚本是否能正确处理特殊字符：

```bash
# 测试双引号
./create-note.sh iCloud "Notes" "引号测试" '内容包含"双引号"和单引号'

# 测试反斜杠
./create-note.sh iCloud "Notes" "反斜杠测试" "路径: C:\\Users\\test"

# 测试美元符号
./create-note.sh iCloud "Notes" "美元符号测试" "价格: $100"

# 测试换行符
./create-note.sh iCloud "Notes" "换行测试" "第一行<br>第二行<br>第三行"

# 测试 HTML 标签
./create-note.sh iCloud "Notes" "HTML测试" "<div>段落1</div><div>段落2</div>"
```

## 步骤 6: 在 Claude Code 中测试 Skill

### 6.1 安装插件
```bash
cd /Users/leetao/workspace/claude-local-plugins/apple-note-plugin
claude plugin install .claude-plugin
```

### 6.2 在 Claude Code 中测试
打开 Claude Code，尝试以下对话：

```
你: 列出我 Apple Notes 中的所有账户
你: 显示 Notes 文件夹中的所有备忘录
你: 创建一个新备忘录，标题是"购物清单"，内容是"牛奶、鸡蛋、面包"
你: 搜索包含"测试"的备忘录
你: 读取名为"Claude Test"的备忘录内容
```

## 常见问题排查

### 权限错误
如果看到 `Error: Notes got an error: Not authorized to access scripting terms`
```
解决: 系统设置 > 隐私与安全性 > 自动化 > 找到 Claude Code > 启用 Notes
```

### 账户名错误
如果看到 `Error: Can't get account "xxx"`
```
解决: 先运行 ./list-accounts.sh 获取正确的账户名
```

### 文件夹不存在
如果看到 `Error: Can't get folder "xxx"`
```
解决: 先运行 ./list-folders.sh 获取正确的文件夹名
```
