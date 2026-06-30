-- ============================================================
--  Share File · Supabase 초기 설정 (한 번만 실행)
--
--  사용법:
--    Supabase 대시보드 → 왼쪽 메뉴 [SQL Editor] → [New query]
--    아래 내용 전체를 붙여 넣고 → 오른쪽 [Run] 버튼 클릭. 끝!
--
--  버킷 생성까지 이 SQL이 알아서 처리합니다.
--  (Storage 화면에서 직접 'share_file' 버킷을 미리 만들어 둬도 충돌 없이 동작합니다)
-- ============================================================


-- 1) 파일을 담을 버킷(통) 만들기  (필수, 비공개)
--    이미 있으면 그대로 두고 넘어갑니다.
insert into storage.buckets (id, name, public)
values ('share_file', 'share_file', false)
on conflict (id) do nothing;


-- 2) 파일 원본 이름을 기억하는 표  (필수)
--    저장소에는 안전한 이름으로 저장되므로, 원래 파일명을 따로 보관합니다.
create table if not exists public.file_metadata (
  path          text primary key,   -- 저장소에 저장된 경로
  original_name text not null        -- 사용자가 올린 원래 파일 이름
);

alter table public.file_metadata enable row level security;


-- 3) 업로드 최대 용량 설정  (선택 — 기본 50MB로 충분하면 이 블록은 지워도 됩니다)
--    숫자는 바이트 단위입니다.
--      50MB  = 52428800
--      100MB = 104857600
--      500MB = 524288000
--    아래는 100MB로 늘리는 예시입니다. 원하는 숫자로 바꾸세요.
--    (화면의 "최대 50MB" 안내 문구는 index.html에서 따로 바꿔야 합니다)
update storage.buckets
set file_size_limit = 104857600
where name = 'share_file';
