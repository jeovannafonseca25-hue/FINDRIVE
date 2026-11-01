# FINDRIVE — Documentação Oficial da API RESTful (Requests & Responses)
**Versão:** 1.0.0  
**Base URL:** `https://api.findrive.app/v1`  
**Autenticação:** Bearer Token JWT via Header `Authorization: Bearer <token>`  
**Content-Type Padrão:** `application/json; charset=utf-8`  

---

## Sumário de Endpoints
1. [Autenticação e Perfil do Motorista](#1-autenticação-e-perfil-do-motorista)
2. [Gestão de Veículo e Ponto de Equilíbrio (Break-Even)](#2-gestão-de-veículo-e-ponto-de-equilíbrio-break-even)
3. [Custos Fixos 360° (Casa + Veículo)](#3-custos-fixos-360-casa--veículo)
4. [Motor de Metas Diárias e Modo Folga Garantida](#4-motor-de-metas-diárias-e-modo-folga-garantida)
5. [Controle de Turnos e Monitoramento de Hora Líquida](#5-controle-de-turnos-e-monitoramento-de-hora-líquida)
6. [Reserva de Manutenção e Custo por KM (CPK)](#6-reserva-de-manutenção-e-custo-por-km-cpk)
7. [Transações e Leitura de Comprovantes via OCR](#7-transações-e-leitura-de-comprovantes-via-ocr)
8. [Inteligência de Turno (Smart Shift / Mapa de Calor)](#8-inteligência-de-turno-smart-shift--mapa-de-calor)
9. [Central de Notificações Inteligentes](#9-central-de-notificações-inteligentes)
10. [Relatórios Fiscais (IRPF / MEI)](#10-relatórios-fiscais-irpf--mei)

---

## 1. Autenticação e Perfil do Motorista

### 1.1 POST `/auth/login`
Autentica o motorista e retorna o token JWT e resumo do perfil.

#### Headers
```http
Content-Type: application/json
Accept: application/json
```

#### Request Body
```json
{
  "email": "carlos.motorista@email.com",
  "password": "SenhaSegura@2026"
}
```

#### Response `200 OK`
```json
{
  "success": true,
  "data": {
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "refreshToken": "d8f49b10-23b9-4a92-8012...",
    "expiresIn": 86400,
    "driver": {
      "id": "drv_8849201",
      "name": "Carlos Eduardo da Silva",
      "email": "carlos.motorista@email.com",
      "phone": "+5511987654321",
      "platformModes": ["uber", "99_pop"],
      "hasVehicleConfigured": true,
      "activeVehicleId": "veh_0921"
    }
  }
}
```

#### Response `401 Unauthorized`
```json
{
  "success": false,
  "error": {
    "code": "AUTH_INVALID_CREDENTIALS",
    "message": "E-mail ou senha incorretos."
  }
}
```

---

## 2. Gestão de Veículo e Ponto de Equilíbrio (Break-Even)

### 2.1 POST `/vehicles`
Cadastra ou atualiza o perfil do veículo do motorista (Alugado ou Próprio).

#### Request Body (Veículo Alugado)
```json
{
  "type": "car",
  "model": "Chevrolet Onix 1.0",
  "plate": "BRA2E19",
  "year": 2024,
  "regime": "rented",
  "rental": {
    "rentalCompany": "Localiza Meoo / Zarp",
    "periodicity": "weekly",
    "costAmount": 680.00,
    "paymentDueDayOfWeek": 3
  },
  "currentOdometerKm": 48250,
  "fuelType": "flex_ethanol",
  "fuelEfficiencyKmPerLiter": 11.2
}
```

#### Request Body (Veículo Próprio)
```json
{
  "type": "car",
  "model": "Renault Kwid Zen",
  "plate": "RNT4G88",
  "year": 2022,
  "regime": "owned",
  "ownedCosts": {
    "financingMonthlyInstallment": 890.00,
    "ipvaAnnual": 1400.00,
    "insuranceAnnual": 2400.00,
    "licensingAnnual": 160.00,
    "fipeValue": 45000.00
  },
  "currentOdometerKm": 72400,
  "fuelType": "flex_gasoline",
  "fuelEfficiencyKmPerLiter": 13.8
}
```

#### Response `201 Created`
```json
{
  "success": true,
  "data": {
    "vehicleId": "veh_0921",
    "regime": "rented",
    "model": "Chevrolet Onix 1.0",
    "weeklyRentalCost": 680.00,
    "dailyDilutedCost": 97.14,
    "breakEven": {
      "ridesNeededPerWeek": 28,
      "estimatedHoursToCover": 18.5,
      "breakEvenDayOfWeek": "Quarta-feira",
      "breakEvenStatusMessage": "A partir da 28ª corrida da semana, todo ganho é lucro líquido."
    }
  }
}
```

---

## 3. Custos Fixos 360° (Casa + Veículo)

### 3.1 GET `/expenses/fixed-monthly`
Retorna a consolidação de custos fixos do motorista (Casa + Veículo).

#### Response `200 OK`
```json
{
  "success": true,
  "data": {
    "totalMonthlyFixed": 3840.00,
    "breakdown": {
      "household": {
        "total": 2100.00,
        "items": [
          { "id": "exp_01", "name": "Aluguel Residencial", "amount": 1200.00, "dueDay": 10 },
          { "id": "exp_02", "name": "Energia Elétrica", "amount": 180.00, "dueDay": 15 },
          { "id": "exp_03", "name": "Supermercado Básico", "amount": 600.00, "dueDay": 5 },
          { "id": "exp_04", "name": "Internet Residencial", "amount": 120.00, "dueDay": 20 }
        ]
      },
      "vehicle": {
        "total": 1740.00,
        "items": [
          { "id": "exp_05", "name": "Locação do Veículo (Mensalizada)", "amount": 2720.00, "dueDay": 1 }
        ]
      }
    }
  }
}
```

---

## 4. Motor de Metas Diárias e Modo Folga Garantida

### 4.1 POST `/goals/calculate-reverse`
Executa o algoritmo de Meta Reversa Diária com base nos custos consolidados e dias de trabalho pretendidos.

#### Request Body
```json
{
  "targetMonthlyNetIncome": 4500.00,
  "scheduledDaysOffPerWeek": [0, 1],
  "maintenanceRetentionPercentage": 10.0,
  "averageFuelExpensePercentage": 24.0,
  "platformAverageFeePercentage": 18.0
}
```

#### Response `200 OK`
```json
{
  "success": true,
  "data": {
    "summary": {
      "daysWorkedPerMonth": 22,
      "dailyNetIncomeTarget": 204.55,
      "dailyFixedCostsShare": 174.55,
      "dailyMaintenanceReserve": 44.34,
      "dailyGrossTarget": 443.40,
      "weeklyGrossTarget": 2217.00
    },
    "hourlyEstimates": {
      "estimatedHoursNeededPerDay": 7.8,
      "targetNetHourlyRate": 36.80
    },
    "guaranteedDaysOff": {
      "enabled": true,
      "daysOffCount": 8,
      "redistributionMessage": "Custos fixos de domingos e segundas foram distribuídos nos 5 dias de turno ativo sem gerar déficit no fechamento do mês."
    }
  }
}
```

### 4.2 GET `/goals/daily/today`
Retorna o status em tempo real da meta do dia atual.

#### Response `200 OK`
```json
{
  "success": true,
  "data": {
    "date": "2026-10-30",
    "dailyGrossGoal": 450.00,
    "grossEarnedSoFar": 315.00,
    "remainingToGoal": 135.00,
    "progressPercentage": 70.0,
    "netRealizedSoFar": 198.40,
    "currentOnlineHours": 5.4,
    "currentNetHourlyRate": 36.74,
    "estimatedRemainingHours": 2.1,
    "maintenanceReservedToday": 31.50,
    "fuelSpentToday": 75.00
  }
}
```

---

## 5. Controle de Turnos e Monitoramento de Hora Líquida

### 5.1 POST `/shifts/start`
Inicia um turno de rodagem.

#### Request Body
```json
{
  "startOdometerKm": 48250,
  "initialFuelLevelPercentage": 75,
  "platformsOnline": ["uber", "99_pop"]
}
```

#### Response `201 Created`
```json
{
  "success": true,
  "data": {
    "shiftId": "shf_99410",
    "status": "active",
    "startedAt": "2026-10-30T14:00:00Z",
    "startOdometerKm": 48250
  }
}
```

### 5.2 POST `/shifts/{id}/stop`
Finaliza o turno, consolida km rodados e calcula a hora líquida real do período.

#### Request Body
```json
{
  "endOdometerKm": 48430,
  "grossEarnings": 380.00,
  "ridesCompletedCount": 14,
  "fuelRefillCost": 85.00
}
```

#### Response `200 OK`
```json
{
  "success": true,
  "data": {
    "shiftId": "shf_99410",
    "durationHours": 7.5,
    "totalKm": 180,
    "grossEarnings": 380.00,
    "fuelCost": 85.00,
    "cpkMaintenanceCost": 28.80,
    "fixedCostShare": 65.00,
    "netProfit": 201.20,
    "realNetRatePerHour": 26.83,
    "maintenanceTransferredToVault": 38.00
  }
}
```

---

## 6. Reserva de Manutenção e Custo por KM (CPK)

### 6.1 GET `/maintenance/vault`
Retorna o saldo da carteira de manutenção preventiva e status dos itens de desgaste.

#### Response `200 OK`
```json
{
  "success": true,
  "data": {
    "vaultBalance": 1240.00,
    "retentionPercentage": 10.0,
    "calculatedCpk": 0.16,
    "componentsWear": [
      {
        "component": "Troca de Óleo e Filtro",
        "lastChangedKm": 42000,
        "currentKm": 48430,
        "nextDueKm": 50000,
        "remainingKm": 1570,
        "estimatedCost": 190.00,
        "status": "warning"
      },
      {
        "component": "Pastilhas de Freio Dianteiras",
        "lastChangedKm": 30000,
        "currentKm": 48430,
        "nextDueKm": 60000,
        "remainingKm": 11570,
        "estimatedCost": 220.00,
        "status": "good"
      },
      {
        "component": "Pneus (4 unidades)",
        "lastChangedKm": 15000,
        "currentKm": 48430,
        "nextDueKm": 65000,
        "remainingKm": 16570,
        "estimatedCost": 1200.00,
        "status": "good"
      }
    ]
  }
}
```

---

## 7. Transações e Leitura de Comprovantes via OCR

### 7.1 POST `/transactions/ocr-extract`
Envia imagem do comprovante de abastecimento ou print de ganhos da Uber/99 para extração inteligente.

#### Request (Multipart Form Data ou Base64)
```json
{
  "imageType": "fuel_receipt",
  "imageBase64": "data:image/jpeg;base64,/9j/4AAQSkZJRgABAQAAAQ..."
}
```

#### Response `200 OK`
```json
{
  "success": true,
  "data": {
    "confidenceScore": 0.96,
    "extracted": {
      "category": "fuel",
      "establishment": "Auto Posto Ipiranga Estrela",
      "fuelType": "Gasolina Comum",
      "liters": 22.45,
      "pricePerLiter": 5.79,
      "totalAmount": 130.00,
      "date": "2026-10-30T18:24:00Z"
    }
  }
}
```

---

## 8. Inteligência de Turno (Smart Shift / Mapa de Calor)

### 8.1 GET `/intelligence/smart-shifts`
Fornece mapa de calor e recomendação dos blocos de horários mais lucrativos na região do motorista.

#### Response `200 OK`
```json
{
  "success": true,
  "data": {
    "recommendedNextShift": {
      "dayOfWeek": "Sexta-feira",
      "recommendedStartTime": "17:30",
      "recommendedEndTime": "23:00",
      "averageExpectedHourlyRate": 48.50,
      "reason": "Pico de saídas de trabalho e eventos noturnos com alta incidência de tarifa dinâmica."
    },
    "heatblocks": [
      { "hour": "06:00 - 09:00", "score": 92, "demandLevel": "high", "expectedNetRate": 42.00 },
      { "hour": "09:00 - 12:00", "score": 45, "demandLevel": "low", "expectedNetRate": 24.00 },
      { "hour": "12:00 - 14:00", "score": 70, "demandLevel": "medium", "expectedNetRate": 33.00 },
      { "hour": "14:00 - 17:00", "score": 50, "demandLevel": "low", "expectedNetRate": 25.00 },
      { "hour": "17:00 - 20:30", "score": 98, "demandLevel": "peak", "expectedNetRate": 51.20 },
      { "hour": "20:30 - 23:30", "score": 85, "demandLevel": "high", "expectedNetRate": 44.00 }
    ]
  }
}
```

---

## 9. Central de Notificações Inteligentes

### 9.1 GET `/notifications/smart-alerts`
Retorna alertas contextuais convertendo despesas em número de corridas médias necessárias.

#### Response `200 OK`
```json
{
  "success": true,
  "data": [
    {
      "id": "notif_9102",
      "type": "bill_due_warning",
      "title": "Conta de Energia Vence Amanhã!",
      "message": "Sua conta de luz de R$ 180,00 vence amanhã. No seu ritmo atual, faltam apenas 2 corridas médias para liquidar essa pendência.",
      "billAmount": 180.00,
      "ridesEquivalent": 2,
      "priority": "high",
      "dueDate": "2026-10-31"
    },
    {
      "id": "notif_9103",
      "type": "maintenance_reminder",
      "title": "Troca de Óleo em 1.570 km",
      "message": "Você já acumulou R$ 1.240,00 no Fundo Preventivo. O valor da troca (R$ 190,00) está 100% coberto!",
      "priority": "medium"
    }
  ]
}
```

---

## 10. Relatórios Fiscais (IRPF / MEI)

### 10.1 GET `/reports/fiscal-summary?month=10&year=2026`
Gera demonstrativo do Carnê-Leão / MEI com segregação de faturamento e despesas operacionais dedutíveis.

#### Response `200 OK`
```json
{
  "success": true,
  "data": {
    "period": "10/2026",
    "grossRevenueTotal": 8750.00,
    "deductibleExpensesTotal": 2420.00,
    "netTaxableBase": 6330.00,
    "deductiblesBreakdown": {
      "fuel": 1820.00,
      "vehicleMaintenance": 420.00,
      "vehicleCleaning": 180.00
    },
    "downloadPdfUrl": "https://api.findrive.app/v1/reports/pdf/fiscal_2026_10.pdf",
    "downloadCsvUrl": "https://api.findrive.app/v1/reports/csv/fiscal_2026_10.csv"
  }
}
```
