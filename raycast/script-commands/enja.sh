#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title enja
# @raycast.mode fullOutput

# Optional parameters:
# @raycast.icon 🤖
# @raycast.packageName Script Commands

# Documentation:
# @raycast.description JA <-> EN translation

SCRIPT='exit 0 if STDIN.read =~ /[\p{Hiragana}\p{Katakana}\p{Han}]/; exit 1'
INPUT=`pbpaste`

llm prompt -m gpt-5-mini -s "あなたは優秀な翻訳家です。次の文章を、日本語の場合は英語に、英語の場合は日本語に翻訳してください。なお、文脈を完全に維持したまま、翻訳結果のテキストのみを出力し、それ以外の前置きや説明、注釈などは一切含めないでください。" "$INPUT"

# if pbpaste | ruby -e $SCRIPT; then
#   # JA -> EN
#   llm prompt -m gpt-5-mini -s "あなたは優秀な翻訳家です。以下の日本語を、文脈を完全に維持したまま、自然で正確な英語に翻訳してください。翻訳結果の英語テキストのみを出力し、それ以外の前置きや説明、注釈などは一切含めないでください。" "$INPUT"
# else
#   # EN -> JA
#   llm prompt -m gpt-5-mini -s "あなたは優秀な翻訳家です。以下の英語の文章を、文脈を完全に理解し、日本の読者にとって最も自然で違和感のない日本語に翻訳してください。文体は「です・ます」調でお願いします。翻訳結果の日本語テキストのみを出力し、それ以外の前置きや説明、注釈などは一切含めないでください。" "$INPUT"
# fi
