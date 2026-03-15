# 📧 AI-Powered Email Auto-Responder with RAG

> Automatically reads incoming emails, summarizes them, generates intelligent AI replies using your knowledge base, and sends draft responses — all without human intervention.

[![n8n](https://img.shields.io/badge/n8n-workflow-orange)](https://n8n.io)
[![DeepSeek](https://img.shields.io/badge/AI-DeepSeek%20R1-purple)](https://deepseek.com)
[![OpenAI](https://img.shields.io/badge/OpenAI-GPT--4-green)](https://openai.com)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

---

## 📌 What It Does

This workflow monitors your inbox via IMAP, reads new emails, converts them to clean text, feeds them to an AI agent with your business knowledge base (RAG), and generates professional replies. The AI can either auto-send replies or save drafts for human review.

**Use case:** A business receives 50+ similar support emails per day. This system handles 80% of them automatically.

---

## 🏗️ Architecture

```
Inbox (IMAP)  ◄─── New Email Arrives
      │
      ▼
HTML → Markdown Converter
      │
      ▼
AI Model (DeepSeek R1 / GPT-4)
      │
   ┌──┴──────────────────┐
   │  RAG Knowledge Base  │ ◄─── Your docs/FAQs
   │  (Vector Search)     │
   └──┬───────────────────┘
      │
      ▼
  AI-Generated Reply
      │
   ┌──┴──────┐
   │         │
   ▼         ▼
Auto-Send  Save Draft
(optional) (for review)
```

---

## ✨ Features

- **IMAP Integration** — Works with Gmail, Outlook, Yahoo, and any IMAP provider
- **HTML Email Parsing** — Cleans HTML emails to plain text before AI processing
- **RAG System** — AI answers based on your actual business knowledge (no hallucinations)
- **DeepSeek R1 Support** — Uses the free DeepSeek R1 model via OpenRouter (zero API cost)
- **Flexible Output** — Auto-send OR save as draft for human review
- **Smart Context** — Understands email thread context for coherent replies
- **Customizable Tone** — Set formal, friendly, or technical response style

---

## 🛠️ Tech Stack

| Component | Technology |
|-----------|-----------|
| Automation Engine | n8n |
| Email Trigger | IMAP (any provider) |
| AI Model | DeepSeek R1 (free) or OpenAI GPT-4 |
| API Provider | OpenRouter |
| RAG | Qdrant / Supabase vector store |
| HTML Processing | n8n Markdown node |

---

## 💰 Cost Efficiency

This workflow uses **DeepSeek R1 via OpenRouter** — the free tier costs $0 for most use cases. Compare:

| Model | Cost per 1M tokens |
|-------|--------------------|
| GPT-4o | $5.00 |
| DeepSeek R1 | $0.55 (or free tier) |
| GPT-4o-mini | $0.15 |

---

## 📋 Prerequisites

- n8n instance
- Email account with IMAP access
- [OpenRouter](https://openrouter.ai) account (free) OR OpenAI API Key
- Optional: Qdrant or Supabase for RAG knowledge base

---

## 🚀 Setup Guide

### Step 1 — Enable IMAP on Your Email
- **Gmail:** Settings → See All Settings → Forwarding and POP/IMAP → Enable IMAP
- **Outlook:** Settings → Mail → Sync email → IMAP

### Step 2 — Configure n8n IMAP Credentials
```
Host: imap.gmail.com (or your provider)
Port: 993
SSL: enabled
Username: your@email.com
Password: your-app-password (NOT your regular password)
```
> ⚠️ For Gmail: Use an [App Password](https://myaccount.google.com/apppasswords), not your real password.

### Step 3 — Set Up AI Model
**Option A (Free) — DeepSeek via OpenRouter:**
1. Create account at [openrouter.ai](https://openrouter.ai)
2. Get API key
3. In n8n, set model to `deepseek/deepseek-r1:free`

**Option B — OpenAI:**
1. Get API key from [platform.openai.com](https://platform.openai.com)
2. Set model to `gpt-4o-mini`

### Step 4 — Add Your Knowledge Base (Optional but Recommended)
Without RAG, the AI uses general knowledge. With RAG, it uses your specific docs.
1. Prepare your FAQ/policy documents
2. Load them into the vector store using the included data ingestion workflow
3. Connect the vector store to the AI agent tool

### Step 5 — Activate and Test
1. Import `workflow.json`
2. Configure all credentials
3. Activate workflow
4. Send a test email to yourself and watch the magic!

---

## 🎛️ Configuration Options

```
AUTO_SEND=false          # Set to true for fully automatic replies
CONFIDENCE_THRESHOLD=0.8 # Only auto-send if AI confidence > 80%
MAX_RESPONSE_LENGTH=500  # Max words in AI reply
REPLY_LANGUAGE=auto      # Reply in same language as incoming email
```

---

## 📁 Project Structure

```
ai-email-autoresponder/
├── workflow.json              # Main auto-responder workflow
├── data-ingestion/
│   └── load_knowledge_base.json  # Workflow to populate RAG
├── examples/
│   ├── sample_email.txt       # Test email example
│   └── sample_response.txt    # Expected AI output
└── README.md
```

---

## 📄 License

MIT License
