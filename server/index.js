import express from 'express'
import cors from 'cors'
import fs from 'fs'
import path from 'path'
import { fileURLToPath } from 'url'

import convertRouter from './routes/convert.js'
import shortlinkRouter from './routes/shortlink.js'
import healthRouter from './routes/health.js'
import mergeRouter from './routes/merge.js'
import { getRulePresets } from './utils/rules.js'
import { targetDefinitions } from './utils/targets.js'

const __filename = fileURLToPath(import.meta.url)
const __dirname = path.dirname(__filename)

const app = express()
const PORT = process.env.PORT || 3000
const distDir = path.join(__dirname, '../dist')
const hasBuiltFrontend = fs.existsSync(path.join(distDir, 'index.html'))
const shouldServeFrontend = process.env.NODE_ENV === 'production' || hasBuiltFrontend
const trustProxy = process.env.TRUST_PROXY || '1'

app.set('trust proxy', /^\d+$/.test(trustProxy) ? Number(trustProxy) : trustProxy)
app.use(cors())
app.use(express.json({ limit: '1mb' }))
app.use(express.urlencoded({ extended: true, limit: '1mb' }))

app.use('/api/convert', convertRouter)
app.use('/api/shortlink', shortlinkRouter)
app.use('/api/health', healthRouter)
app.use('/api/merge', mergeRouter)
app.use('/s', shortlinkRouter)

app.get('/api/rules/presets', (req, res) => {
    res.json(getRulePresets())
})

app.get('/api/targets', (req, res) => {
    res.json(targetDefinitions())
})

const serverHealth = (req, res) => {
    res.json({ status: 'ok', timestamp: new Date().toISOString() })
}

app.get('/healthz', serverHealth)
app.get('/health', (req, res, next) => {
    if (shouldServeFrontend && req.headers.accept?.includes('text/html')) {
        return next()
    }
    return serverHealth(req, res)
})

app.use('/api', (req, res) => {
    res.status(404).json({ error: 'API route not found' })
})

if (shouldServeFrontend) {
    app.use(express.static(distDir, {
        etag: true,
        setHeaders(res, filePath) {
            if (filePath.endsWith('.html')) {
                res.setHeader('Cache-Control', 'no-cache')
            } else if (filePath.includes(`${path.sep}assets${path.sep}`)) {
                res.setHeader('Cache-Control', 'public, max-age=31536000, immutable')
            }
        }
    }))

    app.get('*', (req, res) => {
        res.setHeader('Cache-Control', 'no-cache')
        res.sendFile(path.join(distDir, 'index.html'))
    })
}

app.use((err, req, res, next) => {
    console.error(err.stack)
    res.status(500).json({ error: 'Something went wrong!' })
})

if (path.resolve(process.argv[1] || '') === path.resolve(__filename)) {
    app.listen(PORT, () => {
        console.log(`LaoWang Sub-converter server running on port ${PORT}`)
        console.log(`API: http://localhost:${PORT}/api`)
        console.log(`Health: http://localhost:${PORT}/healthz`)
    })
}

export default app
