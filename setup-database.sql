-- Kleva Customer Onboarding Database Schema
-- Run this in your Supabase SQL Editor

-- Create storage bucket for call recordings
INSERT INTO storage.buckets (id, name, public)
VALUES ('call-recordings', 'call-recordings', true)
ON CONFLICT (id) DO NOTHING;

-- Allow public access to call recordings
DROP POLICY IF EXISTS "Public Access" ON storage.objects;
CREATE POLICY "Public Access"
ON storage.objects FOR SELECT
USING (bucket_id = 'call-recordings');

-- Allow authenticated users to upload
DROP POLICY IF EXISTS "Authenticated users can upload" ON storage.objects;
CREATE POLICY "Authenticated users can upload"
ON storage.objects FOR INSERT
WITH CHECK (bucket_id = 'call-recordings');

-- Create or update customer_onboarding table
CREATE TABLE IF NOT EXISTS customer_onboarding (
  id BIGSERIAL PRIMARY KEY,
  empresa TEXT NOT NULL,
  contacto TEXT NOT NULL,
  email TEXT NOT NULL,
  caso_uso TEXT NOT NULL,
  tipo_mora TEXT, -- Kept for backward compatibility, now nullable
  tipos_mora TEXT[], -- New field for multiple selections
  flujo_conversacion TEXT NOT NULL,
  tono TEXT[], -- Conversation tone options
  canales TEXT[] NOT NULL,
  metodo_carga TEXT NOT NULL,
  datos_contacto TEXT NOT NULL,
  post_conversacion TEXT NOT NULL,
  pais TEXT NOT NULL,
  region TEXT NOT NULL,
  proveedor_telefonia TEXT NOT NULL,
  telefonia_cliente TEXT,
  requerimientos_especiales TEXT,
  call_recordings JSONB DEFAULT '[]'::jsonb, -- Array of {name, url, path}
  is_public_submission BOOLEAN DEFAULT false, -- Track if submitted via public form
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- If table already exists, add new columns if they don't exist
ALTER TABLE customer_onboarding
ADD COLUMN IF NOT EXISTS tipos_mora TEXT[];

ALTER TABLE customer_onboarding
ADD COLUMN IF NOT EXISTS call_recordings JSONB DEFAULT '[]'::jsonb;

ALTER TABLE customer_onboarding
ADD COLUMN IF NOT EXISTS tono TEXT[];

ALTER TABLE customer_onboarding
ADD COLUMN IF NOT EXISTS is_public_submission BOOLEAN DEFAULT false;

-- Make tipo_mora nullable for backward compatibility with new array-based field
ALTER TABLE customer_onboarding
ALTER COLUMN tipo_mora DROP NOT NULL;

-- Enable Row Level Security
ALTER TABLE customer_onboarding ENABLE ROW LEVEL SECURITY;

-- Create policy to allow all access (adjust based on your auth requirements)
CREATE POLICY "Enable all access for now" ON customer_onboarding FOR ALL USING (true);

-- Create an index on created_at for faster sorting
CREATE INDEX idx_customer_onboarding_created_at ON customer_onboarding(created_at DESC);

-- Create an index on empresa for faster searching
CREATE INDEX idx_customer_onboarding_empresa ON customer_onboarding(empresa);
