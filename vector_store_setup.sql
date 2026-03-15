-- =============================================
-- AI Email Autoresponder — Vector Store Setup
-- Run this in your Supabase SQL Editor
-- =============================================

-- Enable pgvector extension
CREATE EXTENSION IF NOT EXISTS vector;

-- Knowledge base documents table
CREATE TABLE IF NOT EXISTS email_knowledge_base (
  id         UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  topic      TEXT NOT NULL,
  content    TEXT NOT NULL,
  metadata   JSONB DEFAULT '{}',
  embedding  VECTOR(1536),
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Index for fast similarity search
CREATE INDEX IF NOT EXISTS email_kb_embedding_idx
ON email_knowledge_base
USING ivfflat (embedding vector_cosine_ops)
WITH (lists = 50);

-- Email logs table (optional — track all processed emails)
CREATE TABLE IF NOT EXISTS email_logs (
  id             UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  sender         TEXT,
  subject        TEXT,
  body_preview   TEXT,
  ai_reply       TEXT,
  status         TEXT CHECK (status IN ('auto_sent', 'draft', 'skipped')),
  confidence     NUMERIC(4,3),
  processed_at   TIMESTAMPTZ DEFAULT NOW()
);

-- Similarity search function (used by n8n RAG node)
CREATE OR REPLACE FUNCTION match_email_knowledge(
  query_embedding VECTOR(1536),
  match_threshold FLOAT DEFAULT 0.75,
  match_count     INT DEFAULT 4
)
RETURNS TABLE (
  id         UUID,
  topic      TEXT,
  content    TEXT,
  metadata   JSONB,
  similarity FLOAT
)
LANGUAGE SQL STABLE
AS $$
  SELECT
    id, topic, content, metadata,
    1 - (embedding <=> query_embedding) AS similarity
  FROM email_knowledge_base
  WHERE 1 - (embedding <=> query_embedding) > match_threshold
  ORDER BY similarity DESC
  LIMIT match_count;
$$;
