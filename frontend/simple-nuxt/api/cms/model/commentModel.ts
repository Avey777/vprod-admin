export interface CommentInfo {
  id?: string;
  content?: string;
  articleId: string;
  nickname: string;
  formatCreatedAt?: string;
}

export interface GetCommentListReq {
  page: number;
  pageSize: number;
  articleId: string;
}
