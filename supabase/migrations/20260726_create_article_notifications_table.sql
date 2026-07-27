CREATE TABLE IF NOT EXISTS article_notifications (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  recipient_id UUID NOT NULL REFERENCES auth.users(id),
  sender_id UUID NOT NULL REFERENCES auth.users(id),
  article_id UUID NOT NULL REFERENCES articles(id) ON DELETE CASCADE,
  comment_id UUID REFERENCES article_comments(id) ON DELETE CASCADE,
  notification_type TEXT NOT NULL DEFAULT 'mention' CHECK (notification_type IN ('mention')),
  is_read BOOLEAN NOT NULL DEFAULT false,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_article_notifications_recipient ON article_notifications(recipient_id, is_read);
CREATE INDEX idx_article_notifications_created ON article_notifications(created_at DESC);

ALTER TABLE article_notifications ENABLE ROW LEVEL SECURITY;

CREATE POLICY article_notifications_select ON article_notifications
  FOR SELECT USING (recipient_id = auth.uid());

CREATE POLICY article_notifications_insert ON article_notifications
  FOR INSERT WITH CHECK (true);

CREATE POLICY article_notifications_update ON article_notifications
  FOR UPDATE USING (recipient_id = auth.uid());

CREATE OR REPLACE FUNCTION create_mention_notifications()
RETURNS TRIGGER AS $$
DECLARE
  mention_text TEXT;
  mentioned_user_id UUID;
  word TEXT;
BEGIN
  mention_text := NEW.comment_text;
  
  FOR word IN SELECT unnest(regexp_split_to_array(mention_text, '\s+'))
  LOOP
    IF word LIKE '@%' THEN
      SELECT id INTO mentioned_user_id
      FROM profiles
      WHERE display_name = substring(word from 2)
      LIMIT 1;
      
      IF mentioned_user_id IS NOT NULL AND mentioned_user_id != NEW.author_id THEN
        INSERT INTO article_notifications (recipient_id, sender_id, article_id, comment_id)
        VALUES (mentioned_user_id, NEW.author_id, NEW.article_id, NEW.id);
      END IF;
    END IF;
  END LOOP;
  
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE TRIGGER trigger_mention_notifications
  AFTER INSERT ON article_comments
  FOR EACH ROW
  EXECUTE FUNCTION create_mention_notifications();
