# Kleva Customer Onboarding

Customer onboarding application for Kleva with Supabase backend.

## Features

- Create, view, edit, and delete customer onboarding forms
- Sidebar navigation for all customers
- Full Supabase integration for data persistence
- Kleva-branded styling with glassmorphism effects

## Setup

### Database Setup

Run this SQL in your Supabase SQL Editor:

```sql
CREATE TABLE customer_onboarding (
  id BIGSERIAL PRIMARY KEY,
  empresa TEXT NOT NULL,
  contacto TEXT NOT NULL,
  email TEXT NOT NULL,
  caso_uso TEXT NOT NULL,
  tipo_mora TEXT NOT NULL,
  flujo_conversacion TEXT NOT NULL,
  canales TEXT[] NOT NULL,
  metodo_carga TEXT NOT NULL,
  datos_contacto TEXT NOT NULL,
  post_conversacion TEXT NOT NULL,
  pais TEXT NOT NULL,
  region TEXT NOT NULL,
  proveedor_telefonia TEXT NOT NULL,
  telefonia_cliente TEXT,
  requerimientos_especiales TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Enable RLS
ALTER TABLE customer_onboarding ENABLE ROW LEVEL SECURITY;

-- Allow all access for now
CREATE POLICY "Enable all access for now" ON customer_onboarding FOR ALL USING (true);
```

## Development

Open `customer-onboarding-app.html` in your browser.

## Deploy

Deploy to Vercel or any static hosting provider.
