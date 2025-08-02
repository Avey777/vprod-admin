export interface ArticleInfo {
  author: string;
  categoryId: number;
  content: string;
  createdAt: number;
  hit: number;
  id: string;
  img: string;
  introduction: string;
  isRecommended: boolean;
  keyword: string;
  source: string;
  status: number;
  subTitle: string;
  tagIds: number[];
  thumbnail: string;
  title: string;
  updatedAt: number;
}

export interface GetArticleListReq {
  categoryId?: number;
  page: number;
  pageSize: number;
  tagId?: number;
  title?: string;
  subTitle?: string;
  keyword?: string;
  sort?: string;
}
