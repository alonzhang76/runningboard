-- ============================================================
-- 文宏科技官网留言表 · Supabase 建表脚本
-- 在 Supabase Dashboard -> SQL Editor 中执行本脚本即可
-- ============================================================

create table if not exists public.messages (
  id          uuid primary key default gen_random_uuid(),
  name        text not null,                -- 姓名
  contact     text not null,                -- 电话 / 邮箱
  message     text not null,                -- 留言内容
  lang        text default 'zh',            -- 提交时使用的语言 zh / en
  user_agent  text,                         -- 浏览器信息（可选，便于排查）
  created_at  timestamptz default now()
);

-- 开启行级安全（RLS）
alter table public.messages enable row level security;

-- 允许匿名访客插入留言（网站表单必需）
create policy "allow anon insert"
  on public.messages for insert
  to anon
  with check (true);

-- 如需允许后台/指定邮箱读取留言，可按需开启（默认不开放）：
-- create policy "allow authenticated select"
--   on public.messages for select
--   to authenticated
--   using (true);

-- 建议索引：按时间倒序查看留言
create index if not exists messages_created_at_idx
  on public.messages (created_at desc);
