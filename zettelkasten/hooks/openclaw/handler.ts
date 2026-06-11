import type { HookHandler } from 'openclaw/hooks';

const REMINDER_NAME = 'ZETTELKASTEN_REMINDER.md';
const REMINDER_PATH = REMINDER_NAME;

const REMINDER_CONTENT = `## Zettelkasten Reminder

Save useful research, analysis, and ideas to the Zettelkasten when appropriate.

- Analysis or summaries of articles, blog posts, or papers -> \`zettelkasten/Literature/\`
- Things learned about technologies or tools -> \`zettelkasten/Literature/\`
- Ideas, reflections, and best practices -> \`zettelkasten/Permanent/\`
- Before creating a new note, search for related notes and add \`[[links]]\` in the body

Basics when creating notes:
- Use the filename format \`YYYY-MM-DD HH-mm.md\`
- For AI-authored notes, add \`ai_generated: true\` and \`ai_model\` to the frontmatter
- Literature notes can include not only a summary but also a \`## User's Thoughts\` section when useful
`;

function isObject(value: unknown): value is Record<string, unknown> {
  return !!value && typeof value === 'object';
}

function isInjectedReminderFile(value: unknown): boolean {
  if (!isObject(value) || value.path !== REMINDER_PATH) {
    return false;
  }

  return value.virtual === true || value.content === REMINDER_CONTENT;
}

const handler: HookHandler = async (event) => {
  if (!event || typeof event !== 'object') {
    return;
  }

  if (event.type !== 'agent' || event.action !== 'bootstrap') {
    return;
  }

  if (!event.context || typeof event.context !== 'object') {
    return;
  }

  const sessionKey = event.sessionKey || '';
  if (sessionKey.includes(':subagent:')) {
    return;
  }

  if (!Array.isArray(event.context.bootstrapFiles)) {
    return;
  }

  const occupiedByOtherFile = event.context.bootstrapFiles.some(
    (file) => isObject(file) && file.path === REMINDER_PATH && !isInjectedReminderFile(file),
  );
  if (occupiedByOtherFile) {
    return;
  }

  const cleanedBootstrapFiles = event.context.bootstrapFiles.filter(
    (file, index, files) =>
      !isInjectedReminderFile(file) ||
      files.findIndex((candidate) => isInjectedReminderFile(candidate)) === index,
  );

  const reminderFile = {
    name: REMINDER_NAME,
    path: REMINDER_PATH,
    content: REMINDER_CONTENT,
    missing: false,
    virtual: true,
  };

  const existingIndex = cleanedBootstrapFiles.findIndex((file) => isInjectedReminderFile(file));
  if (existingIndex === -1) {
    cleanedBootstrapFiles.push(reminderFile);
  } else {
    cleanedBootstrapFiles[existingIndex] = reminderFile;
  }

  event.context.bootstrapFiles = cleanedBootstrapFiles;
};

export default handler;
