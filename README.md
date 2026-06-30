# Share File 📁

**PIN 번호만 알면 누구나 쓸 수 있는, 잠깐 파일을 주고받는 웹사이트입니다.**

카카오톡으로 보내기 애매한 파일, 다른 컴퓨터로 잠깐 옮기고 싶은 파일을
여기에 올려두고 → 상대방이 받아가면 → **자동으로 사라집니다.**

> 컴퓨터/개발을 전혀 몰라도 따라 할 수 있도록 한 단계씩 설명합니다.
> 화면에 나오는 단어가 영어라 낯설 수 있지만, **그대로 누르기만** 하면 됩니다.

---

## 왜 만들었나 (이 프로젝트의 생각)

회사나 보안이 중요한 사무 공간에서는 **구글 드라이브, 네이버 클라우드 같은 공개 클라우드 저장소가 막혀 있는** 경우가 많습니다.
그러다 보니 **내 PC ↔ 내 핸드폰**, 혹은 **옆자리 동료와 파일 하나** 주고받는 사소한 일조차 번거로워집니다.

그래서 이 앱은 이런 상황을 위해 만들어졌습니다.

- 🏢 **보안이 어느 정도 중요한 사무 공간** — PIN으로 잠그고, 파일은 받는 즉시 사라져 흔적이 남지 않습니다.
- 🚫 **공개 클라우드 디스크가 차단된 회사** — 막힌 외부 저장소 대신, 내가 직접 띄운 작은 통로로 파일을 건넵니다.
- 📦 **나만의 작은 저장소** — 거창한 클라우드가 아니라, 두 기기 사이에서 잠깐 쓰고 버리는 개인용 파일 다리.

즉, **"오래 보관하는 창고"가 아니라 "잠깐 건너가는 다리"** 입니다.
파일은 금방 사라지고, 아무 흔적도 남기지 않는 것이 이 앱의 핵심 철학입니다.

---

## 1. 이 앱은 어떻게 생겼나요?

- 웹사이트에 들어가면 **4자리 비밀번호(PIN)** 를 입력하는 화면이 나옵니다.
- PIN을 맞게 입력하면 파일을 **올리고(업로드)** **받을(다운로드)** 수 있습니다.
- 올린 파일은 **1분 정도 지나면 자동으로 삭제**됩니다. (오래 보관하는 곳이 아닙니다)
- 누군가 파일을 **다운로드하면 그 즉시 삭제**됩니다. (한 번 받으면 사라짐)
- 업로드·다운로드 중에는 **빙글빙글 도는 스피너**가 떠서 진행 중임을 알려줍니다.

한마디로 **"잠깐 쓰고 버리는 임시 파일함"** 입니다.

---

## 2. 시작하기 전에 — 무료 계정 2개

이 앱을 인터넷에 올리려면 무료 서비스 2개에 가입해야 합니다. (둘 다 카드 등록 없이 무료)

| 서비스 | 하는 일 | 가입 주소 |
|--------|---------|-----------|
| **Supabase** | 파일을 실제로 보관하는 창고 | https://supabase.com |
| **Vercel** | 웹사이트를 인터넷에 띄워주는 곳 | https://vercel.com |

> 두 사이트 모두 **GitHub 계정으로 가입**하면 가장 편합니다.
> GitHub 계정이 없다면 https://github.com 에서 먼저 무료로 만드세요.

---

## 3. Supabase 설정 (파일 창고 만들기)

### 3-1. 프로젝트 만들기
1. https://supabase.com 접속 → **Start your project** → 로그인
2. **New project** 클릭
3. 이름(아무거나), 비밀번호(메모해두세요), 지역(가까운 곳, 예: Northeast Asia)을 정하고 생성
4. 1~2분 기다리면 준비 완료

### 3-2. 열쇠(연결 정보) 복사해두기
왼쪽 메뉴 맨 아래 **⚙ Project Settings → API** 로 들어가서 아래 2개를 메모장에 복사해 두세요.
나중에 Vercel에 붙여 넣습니다.

- **Project URL** (예: `https://abcd1234.supabase.co`)
- **service_role** 키 (`Project API keys` 항목에 있음 — `anon`이 아니라 **service_role** 입니다. 절대 외부에 공개 금지)

### 3-3. 설정 SQL 한 번 실행하기 — 이게 전부입니다
파일을 담을 **통(버킷)** 과 **파일명 표** 를 만들어야 하는데, 준비된 SQL이 한 번에 해줍니다.

1. 이 프로젝트의 **`supabase/setup.sql`** 파일을 메모장 등으로 엽니다.
2. **전체 내용을 복사**합니다.
3. Supabase 왼쪽 메뉴 **SQL Editor → New query** 에 붙여 넣고 → **Run** 클릭.

이 한 번으로 ① 버킷(`share_file`) 만들기 + ② 파일명 표 만들기 + ③ 업로드 용량 설정이 모두 끝납니다.
**Storage 화면에서 버킷을 따로 만들 필요가 없습니다.**

> 용량을 기본 50MB로 두고 싶으면 `setup.sql` 안의 3번 블록을 지우면 됩니다.
> 화면에서 직접 확인하고 싶다면 **Storage** 메뉴에 `share_file` 통이 생겨 있을 거예요.

---

## 4. 웹사이트 띄우기 (Vercel 배포)

### 4-1. 이 코드를 내 GitHub에 올리기
- 가장 쉬운 방법: GitHub에서 이 저장소를 **Fork** 하거나, 코드를 내 저장소에 **업로드**합니다.
- GitHub 사용이 처음이면, GitHub Desktop(https://desktop.github.com) 앱을 쓰면 끌어다 놓기로 올릴 수 있습니다.

### 4-2. Vercel에서 불러오기
1. https://vercel.com 접속 → 로그인 → **Add New… → Project**
2. 방금 올린 GitHub 저장소를 선택 → **Import**

### 4-3. 환경변수(비밀 설정값) 입력 ⭐ 가장 중요
배포 화면의 **Environment Variables** 칸에 아래 5개를 하나씩 추가합니다.
(`Key`에 이름, `Value`에 값을 넣고 Add 반복)

| Key (이름) | Value (값) | 설명 |
|------------|-----------|------|
| `SUPABASE_URL` | 3-2에서 복사한 **Project URL** | 창고 주소 |
| `SUPABASE_SERVICE_ROLE_KEY` | 3-2에서 복사한 **service_role** 키 | 창고 열쇠 (공개 금지) |
| `PIN_CODE` | 원하는 4자리 숫자 (예: `1234`) | 로그인 비밀번호 |
| `SESSION_SECRET` | 아무 길고 복잡한 문자열 | 로그인 유지용 서명 키 |
| `ALLOWED_IPS` | `*` | 접속 IP 제한 (보통 `*` = 제한 없음) |

> 💡 `SESSION_SECRET` 은 키보드를 마구 친 듯한 긴 문자열이면 됩니다.
> (예: `kf83jd-92mxQ7-randomLongText-do-not-share`)

### 4-4. 배포
**Deploy** 버튼을 누르고 잠시 기다리면 끝!
`https://내프로젝트이름.vercel.app` 같은 주소가 생깁니다. 그 주소로 접속하면 됩니다.

> 환경변수를 나중에 바꿨다면, Vercel의 **Deployments → 점 3개 → Redeploy** 로 다시 배포해야 적용됩니다.

---

## 5. (선택) 아무도 안 받은 파일까지 자동으로 지우기

다운로드된 파일은 자동으로 사라지지만, **아무도 받지 않은 파일**은 그대로 남습니다.
이걸 1분 뒤 자동 삭제하려면 아래 설정을 추가하세요. (조금 어렵습니다 — 건너뛰어도 앱은 동작합니다)

이 기능은 `supabase/functions/delete-files/index.ts` 에 이미 만들어져 있습니다. 배포만 하면 됩니다.

### 5-1. Supabase CLI 설치 후 배포 (컴퓨터에서)
```bash
npm install -g supabase          # Supabase 도구 설치 (Node.js 필요)
supabase login                   # 로그인
supabase link --project-ref 내프로젝트참조ID
supabase secrets set CRON_SECRET=아무거나긴비밀문자열
supabase functions deploy delete-files
```
> `내프로젝트참조ID` 는 Supabase 프로젝트 URL의 `https://` 와 `.supabase.co` 사이 글자입니다.

### 5-2. 1분마다 자동 실행 예약하기
Supabase **SQL Editor** 에서 (먼저 `Database → Extensions` 에서 `pg_cron`, `pg_net` 를 켜두세요):

```sql
select cron.schedule(
  'delete-files-every-min',
  '* * * * *',
  $$
  select net.http_post(
    url     := 'https://내프로젝트참조ID.supabase.co/functions/v1/delete-files',
    headers := '{"X-Cron-Secret": "위에서_정한_CRON_SECRET"}'::jsonb
  )
  $$
);
```

---

## 6. 사용법 (다 만든 뒤)

1. Vercel 주소로 접속
2. 정해둔 **4자리 PIN** 입력 → 자동으로 들어가짐
3. **파일 올리기**: 가운데 네모 칸에 파일을 끌어다 놓거나 클릭해서 선택
4. **파일 받기**: 목록에서 **다운로드** 버튼 클릭 (받으면 그 파일은 사라짐)
5. **로그아웃**: 오른쪽 위 버튼

> 한 번 로그인하면 같은 기기에서 8시간 동안 PIN을 다시 안 물어봅니다.

---

## 7. 자주 묻는 질문

**Q. 파일이 안 올라가요 / "서버 설정 오류" 가 떠요.**
→ Vercel 환경변수 5개가 모두 정확히 들어갔는지 확인하세요. 특히 `SUPABASE_URL`과 `SUPABASE_SERVICE_ROLE_KEY`. 값을 고쳤다면 **Redeploy** 필수.

**Q. PIN이 자꾸 틀렸다고 나와요.**
→ Vercel의 `PIN_CODE` 값과 입력한 숫자가 같은지, 4자리 숫자인지 확인하세요.

**Q. 올린 파일이 너무 빨리 사라져요.**
→ 원래 그런 앱입니다(임시 보관). 보관 시간을 늘리려면 `supabase/functions/delete-files/index.ts`의 `DELETE_AFTER_MS`(1분)와 `index.html`의 카운트다운 값을 함께 바꿔야 합니다.

**Q. `ALLOWED_IPS` 는 뭔가요?**
→ 다운로드를 허용할 IP 목록입니다(콤마 구분, 예: `1.2.3.4,5.6.7.8`). 목록을 지정하면 그 IP들만 다운로드할 수 있고, 그 외 IP는 업로드만 가능해집니다(올리는 곳과 받는 곳을 나누는 용도). 잘 모르면 `*`(제한 없음)로 두세요.

---

## 8. 폴더 구조 (개발자용 참고)

```
share_file/
├── index.html              ← 화면 전체 (HTML/CSS/JS 한 파일)
├── api/                     ← Vercel 서버 기능들
│   ├── _auth.js             · 로그인 토큰 생성/검증
│   ├── auth.js              · PIN 확인 → 토큰 발급
│   ├── check-ip.js          · 접속 IP 권한 확인
│   ├── upload-url.js        · 업로드용 서명 URL 발급
│   ├── metadata.js          · 원본 파일명 저장
│   ├── files.js             · 파일 목록 조회
│   └── download.js          · 다운로드 + 즉시 삭제
├── supabase/
│   ├── setup.sql            · 초기 설정 SQL (표 생성 + 용량) — 한 번 실행
│   ├── config.toml          · Supabase 설정
│   └── functions/delete-files/index.ts  · 자동 삭제 기능
├── Paperlogy-6SemiBold.ttf  ← 글꼴
└── .env.local.example       ← 환경변수 예시
```

---

## 기술 스택

- **프론트엔드**: 순수 HTML / CSS / JavaScript (단일 파일, 빌드 불필요)
- **서버**: Vercel Serverless Functions (Node.js)
- **저장소**: Supabase Storage
- **인증**: 4자리 PIN + HMAC 서명 토큰 (8시간 유효)
- **자동 삭제**: 다운로드 즉시 삭제 + (선택) Supabase Edge Function + pg_cron
