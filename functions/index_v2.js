/**
 * Firebase Cloud Functions for Stock List Manager
 * .xlsb to .xlsx converter API (Node.js Native)
 */

const functions = require('firebase-functions');
const admin = require('firebase-admin');
const XLSX = require('xlsx');

admin.initializeApp();

/**
 * .xlsb 파일을 .xlsx로 변환하는 Cloud Function
 * 
 * HTTP POST 요청:
 * - Body: .xlsb 파일 바이너리 데이터
 * - Content-Type: application/octet-stream
 * 
 * 응답:
 * - Body: .xlsx 파일 바이너리 데이터
 * - Content-Type: application/vnd.openxmlformats-officedocument.spreadsheetml.sheet
 */
exports.convertXlsb = functions
  .region('asia-northeast3') // 서울 리전
  .runWith({
    timeoutSeconds: 120,     // 2분 타임아웃
    memory: '1GB',           // 1GB 메모리 (증가)
  })
  .https.onRequest(async (req, res) => {
    // CORS 헤더 설정
    res.set('Access-Control-Allow-Origin', '*');
    res.set('Access-Control-Allow-Methods', 'POST, OPTIONS');
    res.set('Access-Control-Allow-Headers', 'Content-Type');

    // OPTIONS 요청 처리 (CORS preflight)
    if (req.method === 'OPTIONS') {
      res.status(204).send('');
      return;
    }

    // POST 요청만 허용
    if (req.method !== 'POST') {
      res.status(405).json({ error: 'Method not allowed' });
      return;
    }

    try {
      // 요청 본문에서 .xlsb 바이너리 데이터 읽기
      const xlsbBuffer = req.rawBody || req.body;

      if (!xlsbBuffer || xlsbBuffer.length === 0) {
        res.status(400).json({ 
          error: 'No file data received',
          message: '파일 데이터가 없습니다.'
        });
        return;
      }

      console.log(`📦 Received .xlsb file: ${xlsbBuffer.length} bytes`);

      // SheetJS로 .xlsb 파일 읽기
      const workbook = XLSX.read(xlsbBuffer, { 
        type: 'buffer',
        cellDates: true,
        cellNF: false,
        cellText: false
      });

      console.log(`📊 Workbook loaded: ${workbook.SheetNames.length} sheets`);

      // .xlsx 형식으로 변환
      const xlsxBuffer = XLSX.write(workbook, { 
        type: 'buffer', 
        bookType: 'xlsx',
        compression: true
      });

      console.log(`✅ Conversion successful: ${xlsxBuffer.length} bytes`);

      // .xlsx 파일 응답
      res.set('Content-Type', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
      res.set('Content-Disposition', 'attachment; filename="converted.xlsx"');
      res.status(200).send(xlsxBuffer);

    } catch (error) {
      console.error('❌ Conversion error:', error);
      res.status(500).json({
        error: 'Conversion failed',
        message: error.message || '변환 중 오류가 발생했습니다.'
      });
    }
  });

/**
 * API 서버 상태 확인
 */
exports.health = functions
  .region('asia-northeast3')
  .https.onRequest((req, res) => {
    res.set('Access-Control-Allow-Origin', '*');
    res.status(200).json({
      status: 'ok',
      service: 'xlsb-converter',
      version: '2.0.0',
      runtime: 'nodejs',
      library: 'xlsx (SheetJS)',
      timestamp: new Date().toISOString()
    });
  });
